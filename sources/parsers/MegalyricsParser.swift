import Alamofire

class MegalyricsLyricsParser: LyricsParser {
    override var domain: String {
        return "megalyrics.ru"
    }
    
    override var selector: String {
        return "div.text_inner"
    }
}
