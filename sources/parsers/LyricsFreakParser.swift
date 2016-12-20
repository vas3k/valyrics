import Alamofire

class LyricsfreakLyricsParser: LyricsParser {
    override var domain: String {
        return "www.lyricsfreak.com"
    }
    
    override var selector: String {
        return "div#content_h"
    }
}
