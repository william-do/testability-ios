//
//  TubeModel.swift
//  TestabilityAppStoryboard
//
//  Created by William Do on 11/05/2020.
//  Copyright © 2020 William Do. All rights reserved.
//

struct LineStatus: Encodable, Decodable {
    var statusSeverity: Int
    var statusSeverityDescription: String
}

struct Line: Encodable, Decodable {
    var id: String
    var name: String
    var lineStatuses: [LineStatus] = []
}
