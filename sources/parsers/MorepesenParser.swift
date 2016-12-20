import Alamofire

class MorepesenLyricsParser: LyricsParser {
    override var domain: String {
        return "morepesen.ru"
    }
    
    override var selector: String {
        return ".lyrics pre"
    }
    
    override var encoding: String.Encoding {
        return .windowsCP1251
    }
}

