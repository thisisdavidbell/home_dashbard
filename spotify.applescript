-- Creates a notification with information about the currently playing track

-- Main flow
set currentlyPlayingTrack to getCurrentlyPlayingTrack()
set currentSong to getSong()
set currentArtist to getArtist()
set currentID to getID()
-- displayTrackName(currentlyPlayingTrack)
sendCurrentlyPlaying(currentSong, currentArtist, currentID)

-- Method to get the currently playing track
on getSong()
	tell application "Spotify"
		set currentTrack to name of current track as string
		
		return currentTrack
	end tell
end getSong

on getArtist()
	tell application "Spotify"
		set currentArtist to artist of current track as string
		
		return currentArtist
	end tell
end getArtist

on getID()
	tell application "Spotify"
		set coverArt to artwork url of current track as string
		
		return coverArt
	end tell
end getID

on getCurrentlyPlayingTrack()
	tell application "Spotify"
		set currentArtist to artist of current track as string
		set currentSong to name of current track as string
		
		return currentArtist & " - " & currentSong
	end tell
end getCurrentlyPlayingTrack

-- Method to create a notification
on displayTrackName(trackName)
	display notification "Currently playing " & trackName
	
	-- A delay is set added make sure the notification is shown long enough before the script ends
	delay 1
	
end displayTrackName

-- Method to send currently playing song using curl

on sendCurrentlyPlaying(currentSong, currentArtist, currentID)
	do shell script "curl -d '{ \"auth_token\": \"YOUR_AUTH_TOKEN\",  \"song\": \" " & currentSong & " \", \"artist\": \" " & currentArtist & " \", \"image\": \" " & currentID & " \" }' http://192.168.1.68:3030/widgets/spotify"
	--	do shell script "curl -d '{ \"auth_token\": \"YOUR_AUTH_TOKEN\",  \"artist\": \" " & currentArtist & " \" }' http://192.168.1.68:3030/widgets/spotify"
end sendCurrentlyPlaying