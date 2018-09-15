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

class VoiceListenerModel {
    
    var isStreaming: Variable<Bool>
    
    var recognizedSpeech: Variable<String>
    
    private var speechToText: SpeechToText!
    
    private var accumulator = SpeechRecognitionResultsAccumulator()
    
    init() {
        self.isStreaming = Variable(false)
        self.recognizedSpeech = Variable("")
        
        self.speechToText = SpeechToText(
            username: WatsonSpeech.shared.username,
            password: WatsonSpeech.shared.password
        )
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
            self.accumulator = SpeechRecognitionResultsAccumulator()
            self.speechToText.stopRecognizeMicrophone()
        }
    }
}
