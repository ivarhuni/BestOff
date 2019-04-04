//
//  Extensions.swift
//  BestOff
//
//  Created by Ivar Johannesson on 04/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation


//returns an optional value item, if an item exists at the index
extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//Checks if string contains a URL, returns the absolute strings if there are any
extension String {
    func extractURLs() -> [String] {
        var urls : [String] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url?.absoluteString {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
}
