import Alamofire

class AltwallLyricsParser: LyricsParser {
    override var domain: String {
        return "altwall.net"
    }
    
    override var selector: String {
        return ".content_modern .margin_bottom_medium"
    }
    
    override var encoding: String.Encoding {
        return .windowsCP1251
    }
}

