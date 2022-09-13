//
//  countryList.swift
//  FinalTest_Yeibin
//
//  Created by Yeibin Kang on 2021-12-13.
//

import Foundation
struct CountryList:Codable{
    var countryName:String? = ""
    var capital:String = ""
    var countryCode:String = ""
    var population:Int = 0
    
    //mapping between properties and the actual name of the key in the API response
    enum CodingKeys: String, CodingKey{
        case countryName = "name"
        case capital = "capital"
        case countryCode = "alpha3Code"
        case population = "population"
        
    }
    
    //implementation of the encode()
    func encode(to encoder: Encoder) throws {
        // do nothing
    }
    
    //custom init() - Decodable
    init(from decoder:Decoder) throws{
        let response = try decoder.container(keyedBy: CodingKeys.self)
        
        self.countryName = try response.decodeIfPresent(String.self, forKey: CodingKeys.countryName) ?? "N/A"
        self.capital = try response.decodeIfPresent(String.self, forKey: CodingKeys.capital) ?? "N/A"
        self.countryCode = try response.decodeIfPresent(String.self, forKey: CodingKeys.countryCode) ?? "N/A"
        self.population = try response.decodeIfPresent(Int.self, forKey: CodingKeys.population) ?? 0
    }
    
}
