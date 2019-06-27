//
//  NetworkEndpoints.swift
//  Lodur
//
//  Created by Gunnar Bjarki Bjornsson on 11/08/2017.
//  Copyright © 2017 stokkur. All rights reserved.
//

import Foundation
import Alamofire


/*
 * The endpoints of the api
 */
enum NetworkEndpoint {
    case sendPhoneNumber
    case sendSMS
    case getChargePoints
    case getKeys
    case getHistory
    case getStations
    case logOut
    case push
    case noLogin
    case getCustomer
    case getChargerInfo
}

extension NetworkEndpoint{
    
    var path: String{
        
        switch self {
        case .sendPhoneNumber: 				    return "/api/mobile/sms"
        case .sendSMS: 						    return "/api/mobile/verify"
        case .getChargePoints:                  return "/api/chargepoints/GetChargepointConnectorTypes"
        case .getKeys:                          return "/api/keys/GetUserKeys"
        case .getHistory:                       return "/api/chargesession/getChargeSessions"
        case .getStations:                       return "/api/chargePoints"
        case .logOut:                            return "/api/mobile/logout"
        case .push:                             return "/api/mobile/settings"
        case .noLogin:                          return "/api/mobile/nologin"
        case .getCustomer:                      return "/api/mobile/GetCustomer?mobilePhoneNo="
        case .getChargerInfo:                   return "/api/chargepoints/NumberOfChargersInUse?chargePointId="
        }
    }
}
