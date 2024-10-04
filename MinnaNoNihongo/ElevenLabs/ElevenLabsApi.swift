//
//  ElevenLabsApi.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 06/10/2024.
//

import CryptoKit
import Foundation

final class ElevenLabsApi: Sendable {
    private let apiToken = "xxxx"
    private let baseURL = "https://api.elevenlabs.io"
    
    public func textToSpeech(voice_id: String, text: String, model: String? = nil, language: String?  = nil) async throws -> URL {
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)/v1/text-to-speech/\(voice_id)")!
        let destinationUrl = getDestinationUrl(for: text)
        
        if let destinationUrl = destinationUrl {
            if (!FileManager().fileExists(atPath: destinationUrl.path)) {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue(apiToken, forHTTPHeaderField: "xi-api-key")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("audio/mpeg", forHTTPHeaderField: "Accept")
                
                let parameters: SpeechRequest = SpeechRequest(text: text, voice_settings: ["stability" : 1, "similarity_boost": 1], model: model, language: language)
                
                guard let jsonBody = try? JSONEncoder().encode(parameters) else {
                    throw WebAPIError.unableToEncodeJSONData
                }
                
                request.httpBody = jsonBody
                
                do {
                    let (data, _) = try await session.data(for: request)
                    try? data.write(to: destinationUrl)
                    return destinationUrl
                }
                catch(let error) {
                    throw WebAPIError.httpError(message: error.localizedDescription)
                }
            } else {
                return destinationUrl
            }
        } else {
            throw WebAPIError.badDestinationUrl(message: "Bad destination url")
        }
        
    }
    
    private func getDestinationUrl(for text: String) -> URL? {
        let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let filename = "\(SHA256.hash(data: Data(text.utf8))).mpg"
        let fileURL = directoryUrl?.appendingPathComponent(filename)
        return fileURL
    }
}


public enum WebAPIError: Error {
    case identityTokenMissing
    case unableToDecodeIdentityToken
    case unableToEncodeJSONData
    case unableToDecodeJSONData
    case unauthorized
    case invalidResponse
    case httpError(message: String)
    case httpErrorWithStatus(status: Int)
    case badDestinationUrl(message: String)
}


public struct SpeechRequest: Codable {
    public let text: String
    public let voice_settings: [String: Double]
    public let model_id: String?
    public let language_code: String?

    public init(text: String, voice_settings: [String : Double], model: String?, language: String?) {
        self.text = text
        self.voice_settings = voice_settings
        self.model_id = model
        self.language_code = language
    }
}

