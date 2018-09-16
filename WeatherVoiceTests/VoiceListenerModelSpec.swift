//
//  VoiceListenerModelSpec.swift
//  WeatherVoiceTests
//
//  Created by Sebastian Kasanzew on 09.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import WeatherVoice

class VoiceListenerModelSpec: QuickSpec {

    override func spec() {

        describe("a voice listener model") {

            var voiceModel: VoiceListenerModel!

            beforeEach {
                voiceModel = VoiceListenerModel(username: WatsonSpeech.shared.username,
                                                password: WatsonSpeech.shared.password)
                expect(voiceModel).notTo(beNil())
            }

            context("while not streaming") {

                beforeEach {
                    // TODO figure out issue with project settings
                    //voiceModel.isStreaming.value = false
                }

                it("can start streaming") {
                    //voiceModel.toggleStreaming()
                    //expect( voiceModel.isStreaming.value ).toEventually( beTrue() )
                }
            }

            context("while streaming") {

                beforeEach {
                    //voiceModel.isStreaming.value = true
                }

                it("can start streaming") {
                    //voiceModel.toggleStreaming()
                    //expect( voiceModel.isStreaming.value ).toEventually( beFalse() )
                }
            }
        }
    }
}
