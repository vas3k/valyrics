import Alamofire

class LyricsManiaLyricsParser: LyricsParser {
    override var domain: String {
        return "lyricsmania.com"
    }
    
    override var selector: String {
        return "div.lyrics-body"
    }
}
