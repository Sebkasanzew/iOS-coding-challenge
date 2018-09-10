//
//  GoogleSpeech.swift
//  WeatherVoice
//
//  Created by Sebastian Kasanzew on 09.09.18.
//  Copyright © 2018 Sebastian Kasanzew. All rights reserved.
//

import Foundation

struct GoogleSpeech: Codable {
    
    static let shared = GoogleSpeech(apiKey: "google-cloud-speech-api.key")
    
    let projectID: String
    let privateKeyID: String
    let privateKey: String
    let clientEmail: String
    let clientID: String
    let authURI: String
    let tokenURI: String
    let authProviderX509CertURL: String
    let clientCert: String
    
    private init(apiKey file: String) {
        let api = GoogleSpeech.load(from: file)
        
        self.projectID = api.projectID
        self.privateKeyID = api.privateKeyID
        self.privateKey = api.privateKey
        self.clientEmail = api.clientEmail
        self.clientID = api.clientID
        self.authURI = api.authURI
        self.tokenURI = api.tokenURI
        self.authProviderX509CertURL = api.authProviderX509CertURL
        self.clientCert = api.clientCert
    }
    
    static private func load(from file: String) -> GoogleSpeech {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            fatalError("Could not find google api key file")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let googleSpeech = try decoder.decode( GoogleSpeech.self, from: data)
            return googleSpeech
        } catch {
            fatalError("Could not decode the JSON")
        }
    }
    
    private enum Key: String, CodingKey {
        case projectID = "project_id",
        privateKeyID = "private_key_id",
        privateKey = "private_key",
        clientEmail = "client_email",
        clientID = "client_id",
        authURI = "auth_uri",
        tokenURI = "token_uri",
        authProviderCerURL = "auth_provider_x509_cert_url",
        clientCert = "client_x509_cert_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        
        self.projectID = try values.decode(String.self, forKey: .projectID)
        self.privateKeyID = try values.decode(String.self, forKey: .privateKeyID)
        self.privateKey = try values.decode(String.self, forKey: .privateKey)
        self.clientEmail = try values.decode(String.self, forKey: .clientEmail)
        self.clientID = try values.decode(String.self, forKey: .clientID)
        self.authURI = try values.decode(String.self, forKey: .authURI)
        self.tokenURI = try values.decode(String.self, forKey: .tokenURI)
        self.authProviderX509CertURL = try values.decode(String.self, forKey: .authProviderCerURL)
        self.clientCert = try values.decode(String.self, forKey: .clientCert)
    }
    
}
