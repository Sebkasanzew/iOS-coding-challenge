//
//  WeatherResult.swift
//  WeatherVoice
//
//  Created by Gast on 16.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import Foundation

/**
 The result from the OpenWeatherMap API:
 https://openweathermap.org/current
 
 - Example:
 {
    "coord":{
        "lon":139,
        "lat":35
    },
    "sys": {
        "country":"JP",
        "sunrise":1369769524,
        "sunset":1369821049
    },
    "weather": [
        {
            "id":804,
            "main":"clouds",
            "description":"overcast clouds",
            "icon":"04n"
        }
    ],
    "main": {
        "temp":289.5,
        "humidity":89,
        "pressure":1013,
        "temp_min":287.04,
        "temp_max":287.04
    },
    "wind": {
        "speed":7.31,
        "deg":187.002
    },
    "rain": {
        "3h":0
    },
    "clouds": {
        "all":92
    },
    "dt":1369824698,
    "id":1851632,
    "name":"Shuzenji",
    "cod":200
 }
 */
struct WeatherResult: Codable {
    let weather: [Weather]
    let main: WeatherMain
    let name: String

    /*
    let coord: Coordinates
    let sys: Sys
    let wind: Wind
    let rain: Rain
    let clouds: Clouds
    let dt: Int
    let id: Int
    let cod: Int
    */

    private enum Key: String, CodingKey {
        case weather, main, name
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)

        self.weather = try values.decode([Weather].self, forKey: .weather)
        self.main = try values.decode(WeatherMain.self, forKey: .main)
        self.name = try values.decode(String.self, forKey: .name)
    }
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Sys: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct Weather: Codable {
    let description: String
    //let id: Int
    //let main: String
    //let icon: String

    private enum Key: String, CodingKey {
        case description
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)

        self.description = try values.decode(String.self, forKey: .description)
    }
}

struct WeatherMain: Codable {
    let temp: Measurement<UnitTemperature>
    let humidity: Int
    let pressure: Measurement<UnitPressure>
    //let tempMin: Measurement<UnitTemperature>
    //let tempMax: Measurement<UnitTemperature>

    private enum Key: String, CodingKey {
        case temp, humidity, pressure
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)

        self.temp = try values.decode(Measurement<UnitTemperature>.self, forKey: .temp)
        self.humidity = try values.decode(Int.self, forKey: .humidity)
        self.pressure = try values.decode(Measurement<UnitPressure>.self, forKey: .pressure)
    }
}

struct Wind: Codable {
    let speed: Measurement<UnitSpeed>
    let deg: Measurement<UnitAngle>
}

struct Rain: Codable {
    let time: Int
}

struct Clouds: Codable {
    let all: Int
}
