import Alamofire
import Fuzi

class GoogleLyricsSearch {
    let searchEndpoint = "https://www.google.com/search"
    
    let parsers: [LyricsParser] = [
        GeniusLyricsParser(),
        SoundMeaningsLyricsParser(),
        LyricsfreakLyricsParser(),
        LyricsManiaLyricsParser(),
        SongLyricsLyricsParser(),
        Mp3TextLyricsParser(),
        MegalyricsLyricsParser(),
        MusixmatchLyricsParser(),
        TextLyricsLyricsParser(),
        AltwallLyricsParser(),
        MorepesenLyricsParser()
    ]
    
    var links: NodeSet? = nil
    
    func searchForLyrics(artist: String, title: String, completion: @escaping (_ result: LyricsParserResult) -> Void) {
        let searchRequestParameters: Parameters = [
            "oe": "utf8",
            "ie": "utf8",
            "source": "uds",
            "start": 0,
            "hl": "ru",
            "gws_rd": "ssl",
            "q": artist + " " + title + " lyrics"
        ]
        
        Alamofire.request(searchEndpoint, parameters: searchRequestParameters)
            .validate(statusCode: 200..<300)
            .responseData { response in
                if let data = response.result.value, let text = String(data: data, encoding: .utf8) {
                    let document = try? HTMLDocument(string: text, encoding: String.Encoding.utf8)
                    if document == nil {
                        completion(.Failure("Search results error"))
                        return
                    }
                    
                    self.links = document!.css("h3 a")
                    
                    if self.links!.count == 0 {
                        completion(.Failure("No tracks found"))
                        return
                    }
                    
                    self.findGoodLink(atIndex: 0, completion: completion)
                }
        }
    }
    
    
    func findGoodLink(atIndex: Int, completion: @escaping (_ result: LyricsParserResult) -> Void) {
        if atIndex >= self.links!.count {
            completion(.Failure("index > tracks.count"))
            return
        }
        
        let linkNode = self.links![atIndex]
        
        guard let linkHref = linkNode["href"] else {
            return self.findGoodLink(atIndex: atIndex + 1, completion: completion)
        }
        
        guard let linkString = URLComponents(string: linkHref)?.queryItems?.filter({$0.name == "q"}).first?.value else {
            return self.findGoodLink(atIndex: atIndex + 1, completion: completion)
        }
        
        guard let resultURL = URL(string: linkString) else {
            return self.findGoodLink(atIndex: atIndex + 1, completion: completion)
        }
        
        print("Google: ", resultURL)
        
        var parserTriggered = false
    
        for parser in self.parsers {
            if resultURL.host == parser.domain {
                parserTriggered = true
                print("Parser found", parser.domain)
                parser.getLyricsString(url: resultURL) { result in
                    switch result {
                    case .Success:
                        completion(result)
                        return
                    case .Failure:
                        return self.findGoodLink(atIndex: atIndex + 1, completion: completion)
                    }
                }
                break
            }
        }
        
        if !parserTriggered {
            return self.findGoodLink(atIndex: atIndex + 1, completion: completion)
        }
    }
    
}
