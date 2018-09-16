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

class VoiceListenerViewController: UIViewController {

    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var speechOutputLabel: UILabel!
    @IBOutlet weak var weatherOutput: UILabel!

    private var locationManager: CLLocationManager!

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
        self.registerWeatherResultTextListener()
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
        self.model.isStreaming.asObservable()
            .map { isStreaming in
                // TODO implement L10n as soon as possible in a real project
                return isStreaming ? "Stop" : "Start"
            }
            .bind(to: self.voiceButton.rx.title(for: .normal) )
            .disposed(by: self.disposeBag)
    }

    private func registerSpeechOutputListener() {
        self.model.recognizedSpeech.asObservable()
            .bind(to: self.speechOutputLabel.rx.text)
            .disposed(by: self.disposeBag)
    }

    private func registerWeatherResultTextListener() {
        self.model.weatherResultText.asObservable()
            .bind(to: self.weatherOutput.rx.text)
            .disposed(by: self.disposeBag)
    }
}

extension VoiceListenerViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.model.location = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.weatherOutput.text = "Failed to find your location: \(error.localizedDescription)"
    }
}
