import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {
    @IBOutlet weak var widgetTitleLabel: NSTextField!
    @IBOutlet weak var widgetArtistLabel: NSTextField!
    @IBOutlet weak var widgetLyricsLabel: NSTextField!
    
    let checkSpotifyScript = "set currentlyPlayingTrack to getCurrentlyPlayingTrack() \n" +
        "on getCurrentlyPlayingTrack() \n" +
            "if application \"Spotify\" is running then \n" +
                "tell application \"Spotify\" \n" +
                    "set currentArtist to artist of current track as string \n" +
                    "set currentTrack to name of current track as string \n" +
                    "return currentArtist & \"<<|asn|>>\" & currentTrack \n" +
                "end tell \n" +
            "end if \n" +
        "end getCurrentlyPlayingTrack"
    
    let checkITunesScript = "set currentlyPlayingTrack to getCurrentlyPlayingTrack() \n" +
        "on getCurrentlyPlayingTrack() \n" +
            "if application \"iTunes\" is running then \n" +
                "tell application \"iTunes\" \n" +
                    "set currentArtist to the artist of the current track \n" +
                    "set currentTitle to the name of the current track \n" +
                    "return currentArtist & \"<<|asn|>>\" & currentTitle \n" +
                "end tell \n" +
            "end if \n" +
        "end getCurrentlyPlayingTrack"
    
    override var nibName: String? {
        return "TodayViewController"
    }
   
   var completionHandler: ((NCUpdateResult) -> Void)?

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        self.completionHandler = completionHandler
        let services = [self.checkSpotifyScript, self.checkITunesScript]
        var isRunning = false
        
        for service in services {
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: service) {
                if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
                    if let outputString = output.stringValue {
                        let trackArtistAndTitle = outputString.components(separatedBy: "<<|asn|>>")
                        let trackArtist = trackArtistAndTitle[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let trackTitle = trackArtistAndTitle[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        self.updateLyrics(trackArtist: trackArtist, trackTitle: trackTitle, completionHandler: completionHandler)
                        isRunning = true
                        break
                    }
                } else if (error != nil) {
                    print("error: \(error)")
                }
            }
        }
        
        if isRunning == false {
            self.widgetLyricsLabel.stringValue = "Spotify/iTunes is not running"
        }
        
        let defaults = UserDefaults(suiteName: "group.ru.vas3k.lyrics")
        if let lyricsAlignment = defaults?.object(forKey: "lyricsAlignment") as? Int, lyricsAlignment == 0 {
            self.widgetLyricsLabel.alignment = .left
        } else {
            self.widgetLyricsLabel.alignment = .center
        }
        
        completionHandler(.newData)
    }
    
    func updateLyrics(trackArtist: String, trackTitle: String, completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        self.widgetArtistLabel.stringValue = trackArtist
        self.widgetTitleLabel.stringValue = trackTitle
        self.widgetLyricsLabel.stringValue = "Loading...";
        self.widgetLyricsLabel.sizeToFit()
        
        let google = GoogleLyricsSearch()
        google.searchForLyrics(artist: trackArtist, title: trackTitle) { result in
            switch result {
            case .Success(let lyricsString):
                print("Google success: \(lyricsString)")
                self.widgetLyricsLabel.stringValue = lyricsString;
                self.widgetLyricsLabel.sizeToFit()
            case .Failure(let error):
                print("Google failed: \(error)")
                self.widgetLyricsLabel.stringValue = "Lyrics not found :(";
                self.widgetLyricsLabel.sizeToFit()
            }
            completionHandler(.newData)
        }
    }
   
   @IBAction func didClickReloadButton(_ sender: NSButton) {
      widgetPerformUpdate(completionHandler: self.completionHandler!)
   }
}
