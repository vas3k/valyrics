import Foundation
import Alamofire
import Fuzi

enum LyricsParserResult {
    case Success(String)
    case Failure(String)
}

class LyricsParser {
    let chrome = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"
    
    let scriptRegex = try! NSRegularExpression(pattern: "<script\\b[^>]*>([\\s\\S]*?)<\\/script>", options: .caseInsensitive)
    let commentRegex = try! NSRegularExpression(pattern: "<!--([\\s\\S]*?)-->", options: .caseInsensitive)
    let brRegex = try! NSRegularExpression(pattern: "<br\\b[^>]*>", options: .caseInsensitive)
    let allTagsRegex = try! NSRegularExpression(pattern: "<([\\s\\S]*?)>", options: .caseInsensitive)
    let doubleNewlinesRegex = try! NSRegularExpression(pattern: "(\n\n)", options: .caseInsensitive)
    
    var domain: String {
        return ""
    }
    
    var selector: String {
        return "div.lyrics"
    }
    
    var encoding: String.Encoding {
        return .utf8
    }
    
    public func getLyricsString(url: URL, completion: @escaping (_ result: LyricsParserResult) -> Void) {
        Alamofire.request(url)
            .responseData { response in
                print("Response", response)
                if let data = response.result.value, let text = String(data: data, encoding: self.encoding) {
                    if let document = try? HTMLDocument(string: text, encoding: self.encoding) {
                        return self.parseHTML(html: document, completion: completion)
                    }
                }
                completion(.Failure("No lyrics"))
                return
        }
    }
    
    public func parseHTML(html: HTMLDocument, completion: @escaping (_ result: LyricsParserResult) -> Void) {
        var lyricsString: String = ""
        
        for lyricsBlock in html.css(self.selector) {
            lyricsString += self.truncateHTML(string: lyricsBlock.rawXML)
            lyricsString += "\n"
        }
        
        if lyricsString.characters.count > 100 {
            completion(.Success(lyricsString))
        } else {
            completion(.Failure("Parser error"))
        }
    }
    
    public func truncateHTML(string: String) -> String {
        let stringWithoutScript = self.scriptRegex.stringByReplacingMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: string.characters.count), withTemplate: "")
        let stringWithoutComments = self.commentRegex.stringByReplacingMatches(in: stringWithoutScript, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: stringWithoutScript.characters.count), withTemplate: "")
        let stringWithoutBr = self.brRegex.stringByReplacingMatches(in: stringWithoutComments, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: stringWithoutComments.characters.count), withTemplate: "\n")
        let stringWithoutTags = self.allTagsRegex.stringByReplacingMatches(in: stringWithoutBr, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: stringWithoutBr.characters.count), withTemplate: "\n")
        let stringWithoutDoubleNewlines = self.doubleNewlinesRegex.stringByReplacingMatches(in: stringWithoutTags, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: stringWithoutTags.characters.count), withTemplate: "\n")
        let trimmedString = stringWithoutDoubleNewlines.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString;
    }
}
