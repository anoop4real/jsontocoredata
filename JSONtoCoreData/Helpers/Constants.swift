//
//  Constants.swift
//  WorldCountriesSwift
//
//  Created by anoopm.
//  Copyright © 2017 anoopm. All rights reserved.
//

import Foundation


struct Constants {

    struct APIDetails {

        internal enum APIHOST: String {
           case DEV = "rallycoding.herokuapp.com"
        }

        static let APIScheme = "https"
        static let APIHost = APIHOST.DEV.rawValue
        static let APIPath = "/api/music_albums"
    }
}
