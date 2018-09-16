//
//  WatsonSpeechSpec.swift
//  WeatherVoiceTests
//
//  Created by Gast on 16.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import WeatherVoice

class WatsonSpeechSpec: QuickSpec {

    override func spec() {

        describe("a watson apeech api object") {

            it("can encrypt the JSON and initialize") {
                expect( WatsonSpeech.shared ).notTo( beNil() )
            }
        }
    }
}
