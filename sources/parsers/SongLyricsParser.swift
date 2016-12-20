import Alamofire

class SongLyricsLyricsParser: LyricsParser {
    override var domain: String {
        return "songlyrics.com"
    }
    
    override var selector: String {
        return "p#songLyricsDiv"
    }
}
