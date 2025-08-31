//
//  APIService.swift
//  Calculadora
//
//  Created by Nicholas Forte on 31/08/25.
//

import Foundation

// MARK: - Request payload (ajuste conforme sua API aceitar)
struct Message: Codable {
    let role: String // "user" | "system" | "assistant"
    let content: String
}

struct CreateCompletionRequest: Codable {
    let model: String               // ex: "gpt-4"
    let messages: [Message]
    // acrescente flags se a sua API usar (e.g., stream, temperature etc.)
}

protocol ChatRepository {
    func createCompletion(
            model: String,
            messages: [Message],
            completion: @escaping (Result<ChatCompletion, Error>) -> Void)
}

enum ChatRepositoryError: Error {
    case invalidURL
    case badStatus(Int, Data?)
    case decoding(Error)
    case network(Error)
}

final class ApologeticsChatRepository {
    private let session: URLSession
    private let apiKey: String
    private let baseURL: URL

    init(
        session: URLSession = .shared,
        apiKey: String,
        baseURL: URL = URL(string: "https://createhack-grupo-16.apologetics.bot")!
    ) {
        self.session = session
        self.apiKey = apiKey
        self.baseURL = baseURL
    }

//    func createCompletion(
//            model: String,
//            messages: [Message],
//            completion: @escaping (Result<ChatCompletion, Error>) -> Void
//        ) {
//            guard let url = URL(string: "/api/v1/chat/completions", relativeTo: baseURL) else {
//                completion(.failure(ChatRepositoryError.invalidURL))
//                return
//            }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//            let payload = CreateCompletionRequest(model: model, messages: messages)
//
//            do {
//                request.httpBody = try JSONEncoder().encode(payload)
//            } catch {
//                completion(.failure(error))
//                return
//            }
//
//            let task = session.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    completion(.failure(ChatRepositoryError.network(error)))
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse,
//                      (200...299).contains(httpResponse.statusCode),
//                      let data = data else {
//                    completion(.failure(ChatRepositoryError.badStatus(
//                        (response as? HTTPURLResponse)?.statusCode ?? 0, data)))
//                    return
//                }
//
//                do {
//                    let decoded = try JSONDecoder().decode(ChatCompletion.self, from: data)
//                    completion(.success(decoded))
//                } catch {
//                    completion(.failure(ChatRepositoryError.decoding(error)))
//                }
//            }
//
//            task.resume()
//        }
    
    func makeAPIRequest(prompt: String, completition: @escaping((String) -> Void)) {
        let urlString = "https://createhack-grupo-16.apologetics.bot/api/v1/chat/completions"
        guard let url = URL(string: urlString) else {
            print("Erro: URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        

        // Headers
        request.setValue("apg_IoUmbsVAa6Fhh54xEOv8mDLLr9f6", forHTTPHeaderField: "x-api-key")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        
        let mockPrompt = "Sou um missionário brasileiro, atuando na índia, seu trabalho sera me contextualizar conforme: \(prompt)"

        // Body
        let json: [String: Any] = [
            "prompt": mockPrompt,
            "stream": false,
            "response_format": ["type": "text"]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
        } catch {
            print("Erro ao serializar JSON: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Erro no servidor: \(response)")
                return
            }

            if let data = data {
                // Assumindo que o retorno esperado é texto simples, como indicado por "response_format": { "type": "text" }
                if let responseString = String(data: data, encoding: .utf8) {
                    completition(responseString)
                    print("Resposta da API: \(responseString)")
                } else {
                    print("Não foi possível decodificar a resposta como string UTF-8.")
                }
            }
        }

        task.resume()
    }
}
