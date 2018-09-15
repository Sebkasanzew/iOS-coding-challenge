//
//  VoiceListenerModel.swift
//  WeatherVoice
//
//  Created by Sebastian Kasanzew on 09.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import Foundation
import PromiseKit
import AVFoundation
import SpeechToTextV1

class VoiceListenerModel {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    func recordAudio() {
        self.recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try self.recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try self.recordingSession.setActive(true)
            self.recordingSession.requestRecordPermission() { allowed in
                
                DispatchQueue.main.async(.promise) {
                    guard allowed else {
                        throw NSError(domain: "no permission", code: 1) // TODO define specific error case in separate file
                    }
                }.done {
                    print("audio is allowed")
                }.catch { error in
                    // TODO show dialog to user, or change the UI to give the user feedback
                    print("audio not allowed")
                }
            }
        } catch {
            // TODO show dialog to user, or change the UI to give the user feedback
        }
    }
}
