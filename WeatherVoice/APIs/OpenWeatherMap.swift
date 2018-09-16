//
//  OpenWeatherMap.swift
//  WeatherVoice
//
//  Created by Gast on 16.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import Foundation

struct OpenWeatherMap: Codable {

    static let shared = OpenWeatherMap(apiKey: "open-weather-map.key")

    static let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather"

    let key: String

    private init(apiKey file: String) {
        let api = OpenWeatherMap.load(from: file)

        self.key = api.key
    }

    static private func load(from file: String) -> OpenWeatherMap {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            fatalError("Could not find open weather api key file")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let openWeatherMap = try decoder.decode( OpenWeatherMap.self, from: data)
            return openWeatherMap
        } catch {
            fatalError("Could not decode the JSON")
        }
    }

    private enum Key: String, CodingKey {
        case key
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)

        self.key = try values.decode(String.self, forKey: .key)
    }
}
