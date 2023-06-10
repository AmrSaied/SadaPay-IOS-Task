//
//  AppConfiguration.swift
//  Trending
//
//  Created by Amr Saied on 01/03/2023.
//


import Foundation

final class AppConfiguration {
 
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
}
