//
//  NetworkService.swift
//  BestOff
//
//  Created by Ivar Johannesson on 29/03/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation

enum NetworkError : Error{
    case URLError
    case dataError
    case jsonParseError
}

struct BONetworkService {}
