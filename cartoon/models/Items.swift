
import Foundation

struct Items: Codable {
  var id   : String? = nil
  var icon : String? = nil
  var bg   : String? = nil
  var fg   : String? = nil
  var effect: Effects = Effects.none


  enum CodingKeys: String, CodingKey {
    case id   = "id"
    case icon = "icon"
    case bg   = "bg"
    case fg   = "fg"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id   = try values.decodeIfPresent(String.self , forKey: .id   )
    icon = try values.decodeIfPresent(String.self , forKey: .icon )
    bg   = try values.decodeIfPresent(String.self , forKey: .bg   )
    fg   = try values.decodeIfPresent(String.self , forKey: .fg   )
    effect = Effects.none
  }

  init() {}
}
