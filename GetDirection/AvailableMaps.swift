//
//  AvailableMaps.swift
//  GetDirection
//
//  Created by Kiattisak Anoochitarom on 3/13/2558 BE.
//  Copyright (c) 2558 Kiattisak Anoochitarom. All rights reserved.
//

import Foundation

enum AvailableMaps {
    case AppleMaps, GoogleMaps, GoogleMapsWebsite
    
    func urlFormat() -> String {
        switch (self) {
        case .AppleMaps:
            return "http://maps.apple.com/?daddr=%f,+%f&saddr=%f,+%f"
        case .GoogleMaps:
            return "comgooglemaps://?saddr=%f,%f&daddr=%f,%f"
        case .GoogleMapsWebsite:
            return "http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f"
        }
    }
}