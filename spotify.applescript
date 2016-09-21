-- Creates a notification with information about the currently playing track
property spotPause : Çconstant ****kPSpÈ
property spotPlay : Çconstant ****kPSPÈ
-- Main flow
set currentSong to getSong()
set currentArtist to getArtist()
set currentCoverArt to getCoverArt()
set currentState to getState()
sendCurrentlyPlaying(currentSong, currentState, currentArtist, currentCoverArt)

-- Method to get the currently playing track
on getSong()
	try
		tell application "Spotify"
			with timeout of 2 seconds
				set currentTrack to name of current track as string
			end timeout
			return currentTrack
		end tell
	on error
		set currentTrack to "Unknown"
	end try
end getSong

on getState()
	try
		tell application "Spotify"
			with timeout of 2 seconds
				set currentStateConst to player state as string
			end timeout
			considering case
				if currentStateConst = "Çconstant ****kPSpÈ" then
					set currentState to "Paused"
				else if currentStateConst = "Çconstant ****kPSPÈ" then
					set currentState to "Playing"
				else
					set currentState to "Stopped"
				end if
			end considering
			return currentState
		end tell
	on error
		set currentState to "Unknown"
	end try
end getState

on getArtist()
	try
		tell application "Spotify"
			with timeout of 2 seconds
				set currentArtist to artist of current track as string
			end timeout
			return currentArtist
		end tell
	on error
		set currentArtist to "Unknown"
	end try
end getArtist

on getCoverArt()
	try
		tell application "Spotify"
			with timeout of 2 seconds
				set coverArt to artwork url of current track as string
			end timeout
			return coverArt
		end tell
	on error
		set coverArt to "Unknown"
	end try
end getCoverArt

-- Method to send currently playing song using curl

on sendCurrentlyPlaying(currentSong, currentState, currentArtist, currentCoverArt)
	do shell script " curl -m 3 -d \"{ \\\"auth_token\\\": \\\"YOUR_AUTH_TOKEN\\\", \\\"song\\\": \\\" " & currentSong & " \\\", \\\"state\\\": \\\" " & currentState & " \\\", \\\"artist\\\": \\\" " & currentArtist & " \\\", \\\"image\\\": \\\" " & currentCoverArt & " \\\" }\" http://192.168.1.80:3030/widgets/spotify > /dev/null 2>&1 &"
end sendCurrentlyPlaying
