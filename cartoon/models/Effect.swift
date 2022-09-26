//
//  Effect.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit

struct Effect:Codable {
    var thumbUrl:String? = String.empty
    var bgImageUrl:String? = String.empty
    var fgImageUrl:String? = String.empty
    var blendHashKey:String = String.empty
    var name:String? = String.empty
}


//{
//  "thumbUrl": "images/FullChangeover/template42_17/template42_17_icon.png",
//  "bgImageUrl": "images/FullChangeover/template42_17/template42_17_back.png",
//  "fgImageUrl": "images/FullChangeover/template42_17/template42_17_front.png"
//},

struct EffectsArray: Codable {
    let effects: [Effect]
    
    static func parse(jsonData: Data) -> EffectsArray?{
        do {
            let decodedData = try JSONDecoder().decode(EffectsArray.self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }

    static func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
