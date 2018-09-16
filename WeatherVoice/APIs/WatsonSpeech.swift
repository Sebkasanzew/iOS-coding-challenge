//
//  WatsonSpeech.swift
//  WeatherVoice
//
//  Created by Sebastian Kasanzew on 09.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import Foundation

struct WatsonSpeech: Codable {

    static let shared = WatsonSpeech(apiKey: "watson-speech-api.key")

    let username: String
    let password: String

    private init(apiKey file: String) {
        let api = WatsonSpeech.load(from: file)

        self.username = api.username
        self.password = api.password
    }

    static private func load(from file: String) -> WatsonSpeech {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            fatalError("Could not find watson speech api key file")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let watsonSpeech = try decoder.decode( WatsonSpeech.self, from: data)
            return watsonSpeech
        } catch {
            fatalError("Could not decode the JSON")
        }
    }

    private enum Key: String, CodingKey {
        case username
        case password
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)

        self.username = try values.decode(String.self, forKey: .username)
        self.password = try values.decode(String.self, forKey: .password)
    }

}
