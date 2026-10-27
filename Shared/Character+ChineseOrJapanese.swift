
import Foundation

extension Character {
  var isChineseOrJapanese: Bool {
    guard let scalar = self.unicodeScalars.first else { return false }
    if scalar.properties.isIdeographic { return true }
    switch scalar.value {
    case 0x3000 ... 0x303F,
         0x3040 ... 0x30FF,
         0x3100 ... 0x312F, 0x31A0 ... 0x31BF,
         0x31F0 ... 0x31FF,
         0xFE30 ... 0xFE4F,
         0xFF00 ... 0xFF9F, 0xFFE0 ... 0xFFEF:
      return true

    default:
      return false
    }
  }
}
