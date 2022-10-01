
import Foundation

struct EffectsManager: Codable {
  var categories : [Categories]? = []

  enum CodingKeys: String, CodingKey {
    case categories = "categories"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    categories = try values.decodeIfPresent([Categories].self , forKey: .categories )
  }

    init(){}
    
    static func parse(jsonData: Data) -> EffectsManager?{
        do {
            let decodedData = try JSONDecoder().decode(EffectsManager.self, from: jsonData)
            return decodedData
        } catch {
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
                        
    static func loadFullChangeoverData()-> EffectsManager? {
        do {
            if let data = try? EffectsManager.readLocalJSONFile(forName: "fullbody") {
                if let effectsArray = EffectsManager.parse(jsonData: data as! Data) as? EffectsManager{
                return effectsArray
                }
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    static func loadRealisticCartoonData()-> EffectsManager? {
        do {
            if let data = try? EffectsManager.readLocalJSONFile(forName: "profile") {
                if let effectsArray = EffectsManager.parse(jsonData: data as! Data) as? EffectsManager{
                return effectsArray
                }
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    
    static  func loadToonAvatarsData()-> EffectsManager? {
        do {
            if let data = try? EffectsManager.readLocalJSONFile(forName: "cartoon") {
                if let effectsArray = EffectsManager.parse(jsonData: data as! Data) as? EffectsManager{
                return effectsArray
                }
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    
    static func loadStyleTransferData()-> EffectsManager? {
       
        return nil
    }
}
