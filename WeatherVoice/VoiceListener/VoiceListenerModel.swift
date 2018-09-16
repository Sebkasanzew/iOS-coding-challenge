//
//  VoiceListenerModel.swift
//  WeatherVoice
//
//  Created by Sebastian Kasanzew on 09.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift
import SpeechToTextV1
import Alamofire

class VoiceListenerModel {

    var isStreaming: Variable<Bool>
    var recognizedSpeech: Variable<String>
    var weatherResult: Variable<WeatherResult?>

    private var speechToText: SpeechToText!
    private var accumulator = SpeechRecognitionResultsAccumulator()

    init( username: String, password: String ) {
        self.isStreaming = Variable(false)
        self.recognizedSpeech = Variable("")
        self.weatherResult = Variable(nil)

        self.speechToText = SpeechToText( username: username, password: password )
    }

    func toggleStreaming() {
        if !self.isStreaming.value {
            self.isStreaming.value = true
            let failure = { (error: Error) in
                // TODO give user feedback
                print("ERROR: \(error.localizedDescription)")
            }

            var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
            settings.interimResults = true

            self.speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
                self.accumulator.add(results: results)
                self.recognizedSpeech.value = self.accumulator.bestTranscript
            }
        } else {
            self.isStreaming.value = false
            self.speechToText.stopRecognizeMicrophone()
        }
    }

    func getCurrentWeather(lat: Double, lon: Double) {
        let parameters: Parameters = ["lat": lat, "lon": lon, "APPID": OpenWeatherMap.shared.key]

        Alamofire.request(OpenWeatherMap.currentWeatherURL, parameters: parameters).response { response in
            let jsonDecoder = JSONDecoder()

            guard let data = response.data else {
                // TODO user feedback
                fatalError("no weather data available")
            }

            do {
                let weatherData = try jsonDecoder.decode(WeatherResult.self, from: data)
                self.weatherResult.value = weatherData
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
