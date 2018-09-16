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
import CoreLocation

class VoiceListenerModel {

    var isStreaming: Variable<Bool>
    var recognizedSpeech: Variable<String>
    var weatherResult: Variable<WeatherResult?>
    var weatherResultText: Variable<String>

    var location: CLLocation!

    private var speechToText: SpeechToText!
    private var accumulator = SpeechRecognitionResultsAccumulator()

    private let disposeBag = DisposeBag()

    init( username: String, password: String ) {
        self.isStreaming = Variable(false)
        self.recognizedSpeech = Variable("")
        self.weatherResult = Variable(nil)
        self.weatherResultText = Variable("")

        self.speechToText = SpeechToText( username: username, password: password )

        self.registerTextToRequestListener()
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

        Alamofire.request( OpenWeatherMap.currentWeatherURL,
                           parameters: parameters ).responseJSON { response in

            switch response.result {
            case .success:
                if let json = response.result.value as? [String: Any] {
                    let main = json["main"] as? [String: Any]
                    let weather = json["weather"] as? [[String: Any]]

                    // TODO improve text parsing
                    // swiftlint:disable force_cast
                    let temperature = main!["temp"] as! Double //.converted(to: UnitTemperature.celsius).description
                    let description = weather![0]["description"] as! String
                    let cityName = json["name"] as! String
                    // swiftlint:enable force_cast

                    self.weatherResultText.value = "In \(cityName) it's \(temperature - 273.15)°C and \(description)"
                }
            case .failure(let error):
                // TODO add user feedback
                fatalError(error.localizedDescription)
            }
        }
    }

    private func registerTextToRequestListener() {
        self.recognizedSpeech.asObservable().subscribe(onNext: { text in
            if text.contains("weather") {
                if self.location != nil {
                    let (lat, lon) = (self.location.coordinate.latitude, self.location.coordinate.longitude)
                    self.getCurrentWeather(lat: lat, lon: lon)
                } else {
                    self.weatherResultText.value = "Unknown location"
                }
            }
        }).disposed(by: self.disposeBag)
    }
}
