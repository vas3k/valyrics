import Alamofire

class GeniusLyricsParser: LyricsParser {
    override var domain: String {
        return "genius.com"
    }
    
    override var selector: String {
        return "lyrics.lyrics"
    }
}
