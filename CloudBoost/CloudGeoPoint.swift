//
//  CloudGeoPoint.swift
//  CloudBoost
//
//  Created by Randhir Singh on 29/03/16.
//  Copyright © 2016 Randhir Singh. All rights reserved.
//

import Foundation

public class CloudGeoPoint {
    let document = NSMutableDictionary()
    var coordinates = [Double]()
    
    public init(latitude: Double, longitude: Double) throws {
        document["_type"] = "point"
        if( (latitude >= -90.0 && latitude <= 90.0) && (longitude >= -180.0 && longitude<=180.0) ) {
            coordinates.append(longitude)
            coordinates.append(latitude)
            document["coordinates"] = coordinates
            document["longitude"] = longitude
            document["latitude"] = latitude
        } else {
            throw CloudBoostError.InvalidGeoPoint
        }
    }
    
    // MARK; Setters
    
    public func setLongitude(longitude: Double) throws {
        if(longitude >= -180 && longitude <= 180) {
            coordinates[0] = longitude
            document["coordinates"] = coordinates
            document["longitude"] = longitude
        } else {
            throw CloudBoostError.InvalidGeoPoint
        }
    }
    
    public func setLatitude(latitude: Double) throws {
        if(latitude >= -90 && latitude <= 90) {
            coordinates[0] = latitude
            document["coordinates"] = coordinates
            document["latitude"] = latitude
        } else {
            throw CloudBoostError.InvalidGeoPoint
        }
    }
    
    // MARK: Getters
    
    public func getLongitude() -> Double? {
        return document["longitude"] as? Double
    }
    
    public func getLatitude() -> Double? {
        return document["latitude"] as? Double
    }
    
    
}