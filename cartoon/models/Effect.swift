//
//  Effect.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

//import UIKit
//
//struct Effect {
//    var thumbUrl:String? = String.empty
//    var bgImageUrl:String? = String.empty
//    var fgImageUrl:String? = String.empty
//    var blendHashKey:String = String.empty
//    var name:String? = String.empty
//}
//
//struct EffectCodable: Codable {
//  var thumbUrl   : String? = nil
//  var bgImageUrl : String? = nil
//  var fgImageUrl : String? = nil
//
//  enum CodingKeys: String, CodingKey {
//    case thumbUrl   = "thumbUrl"
//    case bgImageUrl = "bgImageUrl"
//    case fgImageUrl = "fgImageUrl"
//  
//  }
//
//  init(from decoder: Decoder) throws {
//    let values = try decoder.container(keyedBy: CodingKeys.self)
//    thumbUrl   = try values.decodeIfPresent(String.self , forKey: .thumbUrl   )
//    bgImageUrl = try values.decodeIfPresent(String.self , forKey: .bgImageUrl )
//    fgImageUrl = try values.decodeIfPresent(String.self , forKey: .fgImageUrl )
//   }
//
//  init() {}
//}
//
//struct EffectsCodable: Codable {
//
//  var effects : [EffectCodable]? = []
//
//  enum CodingKeys: String, CodingKey {
//
//    case effects = "effects"
//  
//  }
//
//  init(from decoder: Decoder) throws {
//    let values = try decoder.container(keyedBy: CodingKeys.self)
//    effects = try values.decodeIfPresent([EffectCodable].self , forKey: .effects )
//   }
//
//    init() {}
//
//    static func parse(jsonData: Data) -> EffectsCodable?{
//        do {
//            let decodedData = try JSONDecoder().decode(EffectsCodable.self, from: jsonData)
//            return decodedData
//        } catch {
//            print("error: \(error)")
//        }
//        return nil
//    }
//
//    static func readLocalJSONFile(forName name: String) -> Data? {
//        do {
//            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
//                
//                let fileUrl = URL(fileURLWithPath: filePath)
//                let data = try Data(contentsOf: fileUrl)
//                return data
//            }
//        } catch {
//            print("error: \(error)")
//        }
//        return nil
//    }
//                        
//    static func loadFullChangeoverData()-> EffectsCodable? {
//        do {
//            if let data = try? EffectsCodable.readLocalJSONFile(forName: "FullChangeover") {
//                if let effectsArray = EffectsCodable.parse(jsonData: data as! Data) as? EffectsCodable{
//                  print("effect list: \(effectsArray.effects)")
//                return effectsArray
//                }
//            }
//        } catch {
//            print("error: \(error)")
//        }
//        return nil
//    }
//    
//    static func loadRealisticCartoonData()-> EffectsCodable? {
//        do {
//            if let data = try? EffectsCodable.readLocalJSONFile(forName: "RealisticCartoon") {
//                if let effectsArray = EffectsCodable.parse(jsonData: data as! Data) as? EffectsCodable{
//                  print("effect list: \(effectsArray.effects)")
//                return effectsArray
//                }
//            }
//        } catch {
//            print("error: \(error)")
//        }
//        return nil
//    }
//    
//    
//    static  func loadToonAvatarsData()-> EffectsCodable? {
//        do {
//            if let data = try? EffectsCodable.readLocalJSONFile(forName: "ToonAvatars") {
//                if let effectsArray = EffectsCodable.parse(jsonData: data as! Data) as? EffectsCodable{
//                  print("effect list: \(effectsArray.effects)")
//                return effectsArray
//                }
//            }
//        } catch {
//            print("error: \(error)")
//        }
//        return nil
//    }
//    
//    
//    static func loadStyleTransferData()-> EffectsCodable? {
//       
//        return nil
//    }
//    
//}
//
//
//
//
//
//
//
//
//
