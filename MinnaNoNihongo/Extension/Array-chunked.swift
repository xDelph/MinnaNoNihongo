//
//  Array-chunked.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 09/10/2024.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    func chunked(maxChunk nb: Int, minSize ln: Int) -> [[Element]] {
//        let rest = self.count % nb;
        let size = Int(Swift.max(floor(Double(self.count / nb)), Double(ln)));
//        let j = 0;
        
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
