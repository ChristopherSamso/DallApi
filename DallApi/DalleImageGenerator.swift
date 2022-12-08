//
//  DalleImageGenerator.swift
//  DallApi
//
//  Created by Christopher Samso on 12/8/22.
//

import SwiftUI

class DalleImageGenerator {
    
    static let shared = DalleImageGenerator()
    let sessionId = UUID().uuidString
    
    private init() {}
    
    func makeSurePromptIsValid(_ prompt: String,_ apiKey: String) async throws -> Bool {
        guard let url = URL(string: "https://api.openai.com/v1/moderations") else {
            throw ImageError.badUrl
        }
        
        let parameters: [String: Any] = [
            "input": prompt
        ]
        
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (response, _) = try await URLSession.shared.data(for: request)
        
        let result = try JSONDecoder().decode(ModerationResponse.self, from: response)
        
        return result.hasIssues == false
    }
    
    func genImage(withPrompt prompt: String, apiKey: String) async throws -> ImageGenerationResponse {
        
        guard try await makeSurePromptIsValid(prompt, apiKey) else {
            throw ImageError.inValidPrompt
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            throw ImageError.badUrl
        }
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": 1,
            "size": "256x256",
            "user": sessionId
        ]
        
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (response, _) = try await URLSession.shared.data(for: request)
        
        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)
        
        return result
    }
}

enum ImageError: Error {
    case inValidPrompt, badUrl
}
