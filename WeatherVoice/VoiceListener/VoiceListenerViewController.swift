//
//  VoiceListenerViewController
//  WeatherVoice
//
//  Created by Sebastian Kasanzew on 09.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SpeechToTextV1
import CoreLocation

class VoiceListenerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var speechOutputLabel: UILabel!
    @IBOutlet weak var weatherOutput: UILabel!

    var locationManager: CLLocationManager!

    private let model = VoiceListenerModel(username: WatsonSpeech.shared.username,
                                           password: WatsonSpeech.shared.password)

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self

        self.registerVoiceButtonListener()
        self.registerStreamingStateListener()
        self.registerSpeechOutputListener()
        self.registerWeatherResultListener()
        self.registerWeatherResultTextListener()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.model.location = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.weatherOutput.text = "Failed to find your location: \(error.localizedDescription)"
    }

    private func registerVoiceButtonListener() {
        self.voiceButton.rx.tap.subscribe( onNext: { _ in
            if !self.model.isStreaming.value {
                self.locationManager.requestLocation()
                self.speechOutputLabel.text = ""
            }

            self.model.toggleStreaming()
            // TODO Add visual feedback for audio processing
        }).disposed(by: self.disposeBag)
    }

    private func registerStreamingStateListener() {
        self.model.isStreaming.asObservable().subscribe(onNext: { isStreaming in
            switch isStreaming {
            case true: // TODO implement L10n as soon as possible in a real project
                self.voiceButton.setTitle("Stop", for: .normal)
            default:
                self.voiceButton.setTitle("Start", for: .normal)
            }
        }).disposed(by: self.disposeBag)
    }

    private func registerSpeechOutputListener() {
        self.model.recognizedSpeech.asObservable().subscribe(onNext: { text in
            self.speechOutputLabel.text = text
        }).disposed(by: self.disposeBag)
    }

    private func registerWeatherResultListener() {
        self.model.weatherResult.asObservable().subscribe(onNext: { result in
            if let result = result {
                let temperature = result.main.temp.converted(to: UnitTemperature.celsius).description
                let description = result.weather.first?.description ?? ""

                let weatherResultText = "\(result.name): \(temperature) \(description)"

                print(weatherResultText)
            } else {
                print("no weather data")
            }
        }).disposed(by: self.disposeBag)
    }

    private func registerWeatherResultTextListener() {
        self.model.weatherResultText.asObservable()
            .bind(to: self.weatherOutput.rx.text)
            .disposed(by: self.disposeBag)
    }
}
