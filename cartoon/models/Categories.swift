
import Foundation

struct Categories: Codable {

  var id      : String?  = nil
  var icon    : String?  = nil
  var colSpan : Int?     = nil
  var type    : String?  = nil
  var items   : [Items]? = []

  enum CodingKeys: String, CodingKey {

    case id      = "id"
    case icon    = "icon"
    case colSpan = "colSpan"
    case type    = "type"
    case items   = "items"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id      = try values.decodeIfPresent(String.self  , forKey: .id      )
    icon    = try values.decodeIfPresent(String.self  , forKey: .icon    )
    colSpan = try values.decodeIfPresent(Int.self     , forKey: .colSpan )
    type    = try values.decodeIfPresent(String.self  , forKey: .type    )
    items   = try values.decodeIfPresent([Items].self , forKey: .items   )
 
  }

  init() {}
}
