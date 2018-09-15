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

class VoiceListenerViewController: UIViewController {

    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var speechOutputLabel: UILabel!
    
    private let model = VoiceListenerModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerVoiceButtonListener()
        self.registerStreamingStateListener()
        self.registerSpeechOutputListener()
    }
    
    private func registerVoiceButtonListener() {
        self.voiceButton.rx.tap.subscribe( onNext: { event in
            if !self.model.isStreaming.value {
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

}
