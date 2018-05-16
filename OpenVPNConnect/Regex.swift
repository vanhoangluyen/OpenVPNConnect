//
//  Regex.swift
//  OVPNv3
//
//  Created by Chung on 4/14/18.
//  Copyright © 2018 Chung. All rights reserved.
//

import UIKit

class Regex {
    
    static func divPattern(with `class`: String) -> String {
        return "<div class=\"\(`class`)\".*>(.*?)</div>"
    }
    
    static func divSoundPronunciationPattern(_ pronunciation: String) -> String {
        return "<div class=\"sound audio_play_button \(pronunciation == "bre" ? "pron-uk" : "pron-us") icon-audio\"(.*?)>"
    }
    
    static func spanPronunciationPatern(_ pronunciation: String) -> String {
        return "<span class=\"\(pronunciation)\">(.*?)<span class=\"separator\">/</span></span>"
    }
    
    static func spanPattern(with `class`: String) -> String {
        return "<span class=\"\(`class`)\".*>(.*?)</span>"
    }
    
    static func pregMatchFirst(_ string: String, regex: String, index: Int = 0) -> String? {
        
        do{
            
            let rx = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            
            if let match = rx.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) {
                
                var result: [String] = stringMatches([match], text: string, index: index)
                return result.count == 0 ? nil : result[0]
                
            } else {
                return nil
            }
            
        } catch {
            return nil
        }
    }
    
    static func pregMatchAll(_ string: String, regex: String, index: Int = 0) -> [String] {
        
        do {
            
            let rx = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            
            let matches: [NSTextCheckingResult] = rx.matches(in: string, options: [], range: NSMakeRange(0, string.count))
            
            return !matches.isEmpty ? stringMatches(matches, text: string, index: index) : []
            
        } catch {
            
            return []
            
        }
        
    }
    
    static func publicKeyMatch(_ string: String, index: Int = 0) -> String? {
        do{
            let rx = try NSRegularExpression(pattern: "(-----BEGIN PUBLIC KEY-----.+?-----END PUBLIC KEY-----)", options: .dotMatchesLineSeparators)
            if let match = rx.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) {
                var result: [String] = stringMatches([match], text: string, index: index)
                return result.count == 0 ? nil : result[0]
            } else {
                return nil
            }

        } catch {
            return nil
        }
    }
    
    // Extract matches from string
    static func stringMatches(_ results: [NSTextCheckingResult], text: String, index: Int = 0) -> [String] {
        
        return results.map {
            let range = $0.range(at: index)
            if text.count > range.location + range.length {
                return (text as NSString).substring(with: range)
            } else {
                return "\(range.location) + \(range.length) ----- \(text.count)"
            }
        }
        
    }
    static func tagPattern(_ tag: String) -> String {
        
        return "<" + tag + "(.*?)>(.*?)</" + tag + ">"
        
    }
    
    static func decodeContents(for ovpnString: String) throws -> String {
        // Filter looking for new lines...
        var lines = ovpnString.components(separatedBy: "\n")
        
        // No lines, no data...
        guard lines.count != 0 else {
            fatalError("Couldn't get data from PEM key: no data available after stripping headers.")
        }
        
        // Strip off any carriage returns...
        lines = lines.map { ($0.replacingOccurrences(of: "\r", with: "")).replacingOccurrences(of: " ", with: "") }
        return lines.joined(separator: "")
    }
    
    static func base64String(for pemString: String) throws -> String {
        
        // Filter looking for new lines...
        var lines = pemString.components(separatedBy: "\n").filter { line in
            return !line.hasPrefix("-----BEGIN") && !line.hasPrefix("-----END")
        }
        
        // No lines, no data...
        guard lines.count != 0 else {
            fatalError("Couldn't get data from PEM key: no data available after stripping headers.")
        }
        
        // Strip off any carriage returns...
        lines = lines.map { ($0.replacingOccurrences(of: "\r", with: "")).replacingOccurrences(of: " ", with: "") }
        return lines.joined(separator: "")
    }
}
