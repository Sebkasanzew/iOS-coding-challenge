//
//  OpenWeatherMapSpec.swift
//  WeatherVoiceTests
//
//  Created by Gast on 16.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import WeatherVoice

class OpenWeatherMapSpec: QuickSpec {

    override func spec() {

        describe("an open weather map object") {

            it("can encrypt the JSON and initialize") {
                expect( OpenWeatherMap.shared ).notTo( beNil() )
            }
        }
    }
}
