import Alamofire

class TextLyricsLyricsParser: LyricsParser {
    override var domain: String {
        return "text-lyrics.ru"
    }
    
    override var selector: String {
        return "div.entry_content"
    }
    
    override var encoding: String.Encoding {
        return .windowsCP1251
    }
}

