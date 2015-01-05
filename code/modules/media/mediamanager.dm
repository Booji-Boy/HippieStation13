/**********************
 * AWW SHIT IT'S TIME FOR RADIO
 *
 * Concept stolen from D2K5
 *
 * Rewritten by N3X15
 ***********************/

// Uncomment to test the mediaplayer
//#define DEBUG_MEDIAPLAYER

// Open up VLC and play musique.
// Converted to VLC for cross-platform and ogg support. - N3X
var/const/PLAYER_HTML={"
<embed type="application/x-vlc-plugin" pluginspage="http://www.videolan.org" />
<object classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codebase="http://download.videolan.org/pub/videolan/vlc/last/win32/axvlc.cab" id="player"></object>
	<script>
function noErrorMessages () { return true; }
window.onerror = noErrorMessages;
function SetMusic(url, time, volume) {
	var vlc = document.getElementById('player');

	// Stop playing
	vlc.playlist.stop();

	// Clear playlist
	vlc.playlist.items.clear();

	// Add new playlist item.
	var id = vlc.playlist.add(url);

	// Play playlist item
	vlc.playlist.playItem(id);

	vlc.input.time = time*1000; // VLC takes milliseconds.
	vlc.audio.volume = volume*100; // \[0-200]
}
	</script>
"}

/* OLD, DO NOT USE.  CONTROLS.CURRENTPOSITION IS BROKEN.
var/const/PLAYER_HTML={"
	<OBJECT id='player' CLASSID='CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6' type='application/x-oleobject'></OBJECT>
	<script>
function noErrorMessages () { return true; }
window.onerror = noErrorMessages;
function SetMusic(url, time, volume) {
	var player = document.getElementById('player');
	player.URL = url;
	player.Controls.currentPosition = time;
	player.Settings.volume = volume;
}
	</script>"}
*/

/mob/proc/update_music()
	if (client && client.media && !client.media.forced)
		client.media.update_music()

/mob/proc/stop_all_music()
	if (client && client.media)
		client.media.push_music("",0,1)

/mob/proc/force_music(var/url,var/start,var/volume=1)
	if (client && client.media)
		client.media.forced=(url!="")
		if(client.media.forced)
			client.media.push_music(url,start,volume)
		else
			client.media.update_music()
	

#ifdef DEBUG_MEDIAPLAYER
#define MP_DEBUG(x) owner << x
#warning Please comment out #define DEBUG_MEDIAPLAYER before committing.
#else
#define MP_DEBUG(x)
#endif

/datum/media_manager
	var/url = ""
	var/start_time = 0
	var/source_volume = 1 // volume * source_volume

	var/volume = 50
	var/client/owner
	var/mob/mob

	var/forced=0

	var/const/window = "rpane.hosttracker"
	//var/const/window = "mediaplayer" // For debugging.

	New(var/mob/holder)
		src.mob=holder
		owner=src.mob.client
		if(owner.prefs && !isnull(owner.prefs.volume))
			volume = owner.prefs.volume

	// Actually pop open the player in the background.
	proc/open()
		owner << browse(PLAYER_HTML, "window=[window]")
		send_update()

	// Tell the player to play something via JS.
	proc/send_update()
		if(!SOUND_STREAMING && url != "")
			return // Nope.
		MP_DEBUG("\green Sending update to VLC ([url])...")
		owner << output(list2params(list(url, (world.time - start_time) / 10, volume*source_volume)), "[window]:SetMusic")

	proc/push_music(var/targetURL,var/targetStartTime,var/targetVolume)
		if (url != targetURL || abs(targetStartTime - start_time) > 1 || abs(targetVolume - source_volume) > 0.1 /* 10% */)
			url = targetURL
			start_time = targetStartTime
			source_volume = Clamp(targetVolume, 0, 1)
			send_update()

	proc/stop_music()
		push_music("",0,1)

	// Scan for media sources and use them.
	proc/update_music()
		var/targetURL = ""
		var/targetStartTime = 0
		var/targetVolume = 0

		if (forced || !owner)
			return

		var/area/A = get_area_master(mob)
		if(!A)
			//testing("[owner] in [mob.loc].  Aborting.")
			stop_music()
			return
		var/obj/machinery/media/M = A.media_source // TODO: turn into a list, then only play the first one that's playing.
		if(M && M.playing)
			targetURL = M.media_url
			targetStartTime = M.media_start_time
			targetVolume = M.volume
			//owner << "Found audio source: [M.media_url] @ [(world.time - start_time) / 10]s."
		//else
		//	testing("M is not playing or null.")
		push_music(targetURL,targetStartTime,targetVolume)

	proc/update_volume(var/value)
		volume = value
		send_update()

/client/verb/change_volume()
	set name = "Set Volume"
	set category = "Preferences"
	set desc = "Set jukebox volume"
	if(!media || !istype(media))
		usr << "You have no media datum to change, if you're not in the lobby tell an admin."
		return
	var/value = input("Choose your Jukebox volume.", "Jukebox volume", media.volume)
	value = round(max(0, min(100, value)))
	media.update_volume(value)
	if(prefs)
		prefs.volume = value
		//prefs.save_preferences_sqlite(src, ckey)