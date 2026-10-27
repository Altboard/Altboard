
import Foundation

enum PeriodShortcut {

  struct Tap {
    let uptime: TimeInterval
    let before: String?
    let after: String?
  }

  static func replacement(before: String?, after: String?, uptime: TimeInterval, previousTap: Tap?) -> String? {
    guard
      let previousTap,
      uptime - previousTap.uptime <= self.maximumTapInterval,
      let before,
      before.last == " ",
      self.isUnmoved(before: before.dropLast(), after: after, since: previousTap)
    else { return nil }
    let text = before.dropLast()
    var core = text.dropLast(text.reversed().prefix(while: self.isQuote).count)
    if text.last == "»" || text.last == "›", core.last?.isWhitespace == true { core = core.dropLast() }
    guard let anchor = core.last, !anchor.isWhitespace, !self.nonEndingMarks.contains(anchor) else { return nil }
    return self.sentenceEnd(after: anchor)
  }

  private static let maximumTapInterval: TimeInterval = 1.2

  private static let matchedContextLength = 16

  private static let nonEndingMarks: Set<Character> = [
    "!",
    ",",
    "-",
    ".",
    ":",
    ";",
    "?",
    "…",
    "\u{2013}",
    "\u{2014}",
    "\u{3001}",
    "\u{3002}",
    "\u{FF01}",
    "\u{FF0C}",
    "\u{FF0E}",
    "\u{FF1A}",
    "\u{FF1B}",
    "\u{FF1F}",
    "\u{FF61}",
    "\u{FF64}",
    "\u{060C}",
    "\u{061B}",
    "\u{061F}",
    "\u{06D4}",
    "\u{0589}",
    "\u{1362}",
    "\u{00B7}",
    "\u{0964}",
    "\u{0965}",
  ]

  private static func isUnmoved(before: Substring, after: String?, since tap: Tap) -> Bool {
    guard let tapBefore = tap.before else { return false }
    let length = self.matchedContextLength
    return before.hasSuffix(tapBefore.suffix(length))
      && (after ?? "").prefix(length) == (tap.after ?? "").prefix(length)
  }

  private static func isQuote(_ character: Character) -> Bool {
    character.unicodeScalars.first?.properties.isQuotationMark ?? false
  }

  private static func sentenceEnd(after character: Character) -> String? {
    if character.isChineseOrJapanese { return "\u{3002}" }
    switch character.unicodeScalars.first?.value ?? 0 {
    case 0x0900 ... 0x0A7F:
      return "\u{0964} "

    case 0x0E00 ... 0x0EFF, 0x0F00 ... 0x109F, 0x1780 ... 0x17FF:
      return nil

    default:
      return ". "
    }
  }
}
