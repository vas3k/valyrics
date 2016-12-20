import Alamofire

class Mp3TextLyricsParser: LyricsParser {
    override var domain: String {
        return "mp3text.ru"
    }
    
    override var selector: String {
        return "div.fullstory"
    }
    
    override var encoding: String.Encoding {
        return .windowsCP1251
    }
}
