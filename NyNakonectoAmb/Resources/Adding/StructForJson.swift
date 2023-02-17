//
//  StructForJson.swift
//  NyNakonectoAmb
//
//  Created by СКБ on 30.10.2022.
//

import Foundation

//struct for getting JSON data(markers) from server
struct GetArrs: Decodable{
    var id: Int
    var street: String
    var name: String
    var description: String
    var gps: String
    var image: String
    var getImage: String
    var createdOn: String

    enum CodingKeys: String, CodingKey {
        case id
        case street
        case name
        case description
        case gps
        case image
        case getImage = "get_image"
        case createdOn = "created_on"
    }
}

var arrOfMarkers = [GetArrs]()
