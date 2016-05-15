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
    
    public func getCoordinates() -> [Double] {
        return coordinates
    }
    
    private func greatCircleFormula(point: CloudGeoPoint) -> Double {
        let dLat = toRad(self.coordinates[1] - point.coordinates[1])
        let dLon = toRad(self.coordinates[0] - point.coordinates[0])
        
        let lat1 = toRad(point.coordinates[1])
        let lat2 = toRad(self.coordinates[1])
        
        var a  = sin(dLat/2.0)*sin(dLat/2)
        a += sin(dLon/2)*sin(dLon/2)
        a += cos(lat1)*cos(lat2)
        let c = 2*atan2(sqrt(a), sqrt(1-a))
        
        return c
    }
    
    private func toRad(number: Double) -> Double {
        let pi = 3.141592653589793
        return number*pi/180.0
    }
    
    public func distanceInKMs(point: CloudGeoPoint) -> Double {
        let earthRedius = 6371.0 //in Kilometer
        return earthRedius * self.greatCircleFormula(point)
    }
    
    public func distanceInMiles(point: CloudGeoPoint) -> Double {
        let earthRedius = 3959.0 //in Kilometer
        return earthRedius * self.greatCircleFormula(point)
    }
    
    public func distanceInRadius(point: CloudGeoPoint) -> Double {
        return self.greatCircleFormula(point)
    }
    
}