set currentlyPlayingTrack to getCurrentlyPlayingTrack()

on getCurrentlyPlayingTrack()
    if application "iTunes" is running then
        tell application "iTunes"
            if exists name of current track then
                set iTrack to the current track
                set currentTrack to the name of iTrack
                set currentArtist to the artist of iTrack
                return currentArtist & "<<|asn|>>" & currentTrack
            end if
        end tell
    end if
end getCurrentlyPlayingTrack

