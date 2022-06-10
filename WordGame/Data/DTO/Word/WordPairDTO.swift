//
//  WordPairDTO.swift
//  WordGame
//
//  Created by Joel Kingsley on 06/05/2022.
//

import Foundation

struct WordPairDTO: Decodable {
    let textEnglish: String
    let textSpanish: String
    
    private enum CodingKeys: String, CodingKey {
        case textEnglish = "text_eng"
        case textSpanish = "text_spa"
    }
    
    func toEntity() -> WordPair {
        return WordPair(
            textEnglish: textEnglish,
            textSpanish: textSpanish
        )
    }
}
