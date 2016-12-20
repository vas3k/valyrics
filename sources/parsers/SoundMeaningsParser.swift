import Alamofire

class SoundMeaningsLyricsParser: LyricsParser {
    override var domain: String {
        return "songmeanings.com"
    }
    
    override var selector: String {
        return "div.lyric-box"
    }
}
