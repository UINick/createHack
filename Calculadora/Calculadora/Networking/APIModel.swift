//
//  APIModel.swift
//  Calculadora
//
//  Created by Nicholas Forte on 31/08/25.
//

import Foundation

struct ChatCompletion: Codable {
    let id: String
    let sources: [Source]
    let object: String
    let created: Int
    let model: String
    let stream: Bool
    let metadata: Metadata
}

struct Source: Codable {
    let title: String
    let lang: String
    let imageURL: String
    let authors: [String]
    let isApproved: Bool
    let weight: Int
    let categories: [Int]
    let collections: [Int]
    let contributors: [Int]
    let team: Int
    let referralURL: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case title, lang
        case imageURL = "image_url"
        case authors
        case isApproved = "is_approved"
        case weight, categories, collections, contributors, team
        case referralURL = "referral_url"
        case id
    }
}

struct Metadata: Codable {
    let anonymous: Bool
    let conversation: String?
    let maxMemories: String?
    let parentURL: String?
    let parentHost: String?
    let session: String?
    let device: String?
    let translation: String?

    enum CodingKeys: String, CodingKey {
        case anonymous, conversation
        case maxMemories = "max_memories"
        case parentURL = "parent_url"
        case parentHost = "parent_host"
        case session, device, translation
    }
}
