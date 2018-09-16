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
    var weatherResultText: Variable<String>

    var location: CLLocation!

    private var speechToText: SpeechToText!
    private var accumulator = SpeechRecognitionResultsAccumulator()

    private let disposeBag = DisposeBag()

    init( username: String, password: String ) {
        self.isStreaming = Variable(false)
        self.recognizedSpeech = Variable("")
        self.weatherResultText = Variable("")

        self.speechToText = SpeechToText( username: username, password: password )

        self.registerTextToRequestListener()
    }

    func toggleStreaming() {
        if !self.isStreaming.value {
            self.isStreaming.value = true
            self.weatherResultText.value = ""

            let failure = { (error: Error) in
                self.weatherResultText.value = error.localizedDescription
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

                    // TODO improve text parsing and remove force casts
                    // swiftlint:disable force_cast
                    let temperature = main!["temp"] as! Double //.converted(to: UnitTemperature.celsius).description
                    let description = weather![0]["description"] as! String
                    let cityName = json["name"] as! String
                    // swiftlint:enable force_cast

                    // TODO parse data (like temperature) into a Measurement object to remove hardcoded calculation of degrees as Celsius
                    let celsius = Int((temperature - 273.15).rounded())
                    self.weatherResultText.value = "In \(cityName) it's \(celsius)°C and \(description)"
                }
            case .failure(let error):
                self.weatherResultText.value = error.localizedDescription
            }
        }
    }

    private func registerTextToRequestListener() {
        self.recognizedSpeech.asObservable()
            .filter { $0.contains("weather") }
            .subscribe(onNext: { _ in
                if self.location != nil {
                    self.getCurrentWeather( lat: self.location.coordinate.latitude,
                                            lon: self.location.coordinate.longitude )
                } else {
                    self.weatherResultText.value = "Unknown location"
                }
            }).disposed(by: self.disposeBag)
    }
}
