//
//  WebService.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 06/10/2024.
//

import Foundation

import SwiftData

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse(with: String)
}

final class WebService: Sendable {
    private let shaKey = "minnaNoNihongoVersion"
    
    @MainActor
    func updateDataInDatabase(modelContainer: ModelContainer) async {
        self.checkForUpdates { isNewFileAvailable in
            Task {
                if isNewFileAvailable {
                    do {
                        print("...downloading...")
                        let itemData: [CardDTO] = try await self.fetchData(fromUrl: "https://raw.githubusercontent.com/xDelph/MinnaNoNihongo/develop/Data/chapters.json")
                        let backgroundActor = ThreadsafeBackgroundChapterActor(modelContainer: modelContainer)
                        try await backgroundActor.updateChapters(itemData)
                        print("...done")
                    } catch {
                        print("Error in updateDataInDatabase")
                        print(error.localizedDescription)
                    }
                } else {
                    print("...done")
                }
            }
        }
    }
    
    private func checkForUpdates(completion: @escaping @Sendable (Bool) -> Void) {
        print("Start checking for updates...")
        let repoUrl = "https://api.github.com/repos/xDelph/MinnaNoNihongo/contents/Data/chapters.json?ref=develop"
        var request = URLRequest(url: URL(string: repoUrl)!)
        request.httpMethod = "GET"
        
        // GitHub requires API requests to have a user-agent
        request.addValue("MinnaNoNihongo", forHTTPHeaderField: "User-Agent")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching file info: \(String(describing: error))")
                completion(false)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let updatedDateString = json?["sha"] as? String {
                    let localSha = self.getLocalSha()
                    if updatedDateString != localSha {
                        completion(true) // New file exists
                        self.saveLocalSha(updatedDateString)
                    } else {
                        print("...no update to do (but we are in memory so doing anyway)...")
                        completion(true) // No update
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(false)
            }
        }
        task.resume()
    }

    private func getLocalSha() -> String? {
        // Implement a method to retrieve the sha/version hash of your locally saved file
        return UserDefaults.standard.string(forKey: shaKey)
    }

    private func saveLocalSha(_ sha: String) {
        UserDefaults.standard.set(sha, forKey: shaKey)
    }

    private func fetchData<T: Codable>(fromUrl: String) async throws -> [T] {
        guard let downloadedData: [T] = await WebService().downloadData(fromURL: fromUrl) else {return []}

        return downloadedData
    }
    
    private func downloadData<T: Codable>(fromURL: String) async -> T? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch let jsonError as NSError {
                throw NetworkError.failedToDecodeResponse(with: jsonError.localizedDescription)
            }
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse(let error) {
            print("Failed to decode response into the given type", error)
        } catch {
            print("An error occured downloading the data")
        }
        
        return nil
    }
}
