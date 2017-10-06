//
//  Filter.swift
//  AVVideoEditor
//
//  Created by Haruya Ishikawa on 2017/10/05.
//  Copyright © 2017 Haruya Ishikawa. All rights reserved.
//

import Foundation

struct Filter: Codable, Equatable {
    
    let name: String
    let filter: String
    
    init(name: String, filter: String) {
        self.name = name
        self.filter = filter
    }
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        return lhs.name == rhs.name && lhs.filter == rhs.filter
    }
}

class FilterManager {
    
    static let availableFilters: [Filter] = {
        guard let jsonURL = Bundle.main.url(forResource: "Filter", withExtension: "json") else {
            fatalError("Missing 'Filter.json' in bundle.")
        }
        
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            return try JSONDecoder().decode([Filter].self, from: jsonData)
        } catch {
            fatalError("Unable to decode Filter JSON: \(error)")
        }
    }()
    
}
