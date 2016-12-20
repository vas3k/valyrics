set currentlyPlayingTrack to getCurrentlyPlayingTrack()

on getCurrentlyPlayingTrack()
    if application "Spotify" is running then
      tell application "Spotify"
        set currentArtist to artist of current track as string
        set currentTrack to name of current track as string
        return currentArtist & "<<|asn|>>" & currentTrack
      end tell
    end if
end getCurrentlyPlayingTrack

