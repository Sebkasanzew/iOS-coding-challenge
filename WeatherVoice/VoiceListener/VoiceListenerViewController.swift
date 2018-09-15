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
    
    var speechToText: SpeechToText!
    var isStreaming = false
    var accumulator = SpeechRecognitionResultsAccumulator()
    
    private let model = VoiceListenerModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.speechToText = SpeechToText(
            username: WatsonSpeech.shared.username,
            password: WatsonSpeech.shared.password
        )
        
        self.registerVoiceButtonListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func registerVoiceButtonListener() {
        self.voiceButton.rx.tap.subscribe( onNext: { event in
            self.buttonAction()
            
            // self.model.recordAudio()
            // TODO Add feedback for audio processing
        }).disposed(by: self.disposeBag)
    }
    
    func buttonAction() {
        if !isStreaming {
            isStreaming = true
            self.voiceButton.setTitle("Stop", for: .normal)
            let failure = { (error: Error) in print(error) }
            var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
            settings.interimResults = true
            
            speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
                self.accumulator.add(results: results)
                print(self.accumulator.bestTranscript)
            }
        } else {
            isStreaming = false
            self.voiceButton.setTitle("Start", for: .normal)
            speechToText.stopRecognizeMicrophone()
        }
    }

}
