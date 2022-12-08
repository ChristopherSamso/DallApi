//
//  ImageGenerationResponse.swift
//  DallApi
//
//  Created by Christopher Samso on 12/8/22.
//

import Foundation

struct ImageGenerationResponse: Codable {
    struct ImageResponse: Codable {
        let url: URL
    }
    
    let created: Int
    let data: [ImageResponse]
}
