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
    "main": {"temp":289.5,"humidity":89,"pressure":1013,"temp_min":287.04,"temp_max":
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
    let coord: Coordinates
    let sys: Sys
    let weather: [Weather]
    let main: WeatherMain
    let wind: Wind
    let rain: Rain
    let clouds: Clouds
    let dt: Int
    let id: Int
    let name: String
    let cod: Int
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
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherMain: Codable {
    let temp: Measurement<UnitTemperature>
    let humidity: Double
    let pressure: Measurement<UnitPressure>
    let tempMin: Measurement<UnitTemperature>
    let tempMax: Measurement<UnitTemperature>
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
