set currentlyPlayingTrack to getCurrentlyPlayingTrack()

on getCurrentlyPlayingTrack()
    if application "iTunes" is running then
        tell application "iTunes"
            set currentArtist to the artist of the current track
            set currentTitle to the name of the current track
            return currentArtist & "<<|asn|>>" & currentTitle
        end tell
    end if
end getCurrentlyPlayingTrack

