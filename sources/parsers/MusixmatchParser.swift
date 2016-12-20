import Alamofire

class MusixmatchLyricsParser: LyricsParser {
    override var domain: String {
        return "www.musixmatch.com"
    }
    
    override var selector: String {
        return ".mxm-lyrics__content"
    }
}
