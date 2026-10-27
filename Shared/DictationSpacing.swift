
import Foundation

enum DictationSpacing {

  static func separators(
    for text: String,
    before: String?,
    after: String?,
    isAddressField: Bool,
  ) -> (leading: String, trailing: String) {
    guard !isAddressField, !text.isEmpty else { return ("", "") }
    let leading = before.map { self.needsLeadingSpace(before: $0[...], text: text[...]) } == true ? " " : ""
    let trailing = after.map { self.needsTrailingSpace(text: text[...], after: $0[...]) } == true ? " " : ""
    return (leading, trailing)
  }

  private static let wordPrefixes: Set<Character> = ["¿", "¡", "@", "#", "/", "\\", "_"]

  private static let closingMarks: Set<Character> = [
    ".",
    ",",
    ";",
    ":",
    "!",
    "?",
    "…",
    ")",
    "]",
    "}",
    "%",
    "\u{060C}",
    "\u{061B}",
    "\u{061F}",
    "\u{06D4}",
    "\u{0964}",
    "\u{0965}",
  ]

  private static let openingQuotes: Set<Character> = ["„", "‚", "«", "‹"]

  private static let guillemetOpeners: [Character: Character] = ["»": "«", "›": "‹"]

  private static let elidedWords: Set = [
    "c",
    "d",
    "j",
    "l",
    "m",
    "n",
    "s",
    "t",
    "qu",
    "jusqu",
    "lorsqu",
    "puisqu",
    "quoiqu",
    "all",
    "bell",
    "coll",
    "dall",
    "dell",
    "nell",
    "quell",
    "quest",
    "sant",
    "sull",
    "tutt",
    "un",
  ]

  private static func needsLeadingSpace(before: Substring, text: Substring) -> Bool {
    guard let last = before.last, let first = text.first, self.canSeparate(last, first) else { return false }
    if first.isNumber, self.endsInNumberSign(before) { return false }
    if first == "-", last.isNumber { return false }
    return !self.opensNextWord(before) && self.dictationStartsWord(text)
  }

  private static func needsTrailingSpace(text: Substring, after: Substring) -> Bool {
    guard let last = text.last, let first = after.first, self.canSeparate(last, first) else { return false }
    if self.isQuote(first) || self.closingMarks.contains(first) { return false }
    if first == "-" {
      guard let next = after.dropFirst().first else { return true }
      return next.isWhitespace || (next.isNumber && !last.isNumber)
    }
    if first.isNumber, self.endsInNumberSign(text) { return false }
    return !self.opensNextWord(text)
  }

  private static func canSeparate(_ left: Character, _ right: Character) -> Bool {
    !left.isWhitespace && !right.isWhitespace && !left.isChineseOrJapanese && !right.isChineseOrJapanese
  }

  private static func endsInNumberSign(_ text: Substring) -> Bool {
    guard let last = text.last else { return false }
    if last == "+" { return true }
    guard last.unicodeScalars.first?.properties.generalCategory == .currencySymbol else { return false }
    let beforeSign = text.dropLast()
    let followsAmount = beforeSign.last?.isNumber == true
      || (beforeSign.last?.isWhitespace == true && beforeSign.dropLast().last?.isNumber == true)
    return !followsAmount
  }

  private static func opensNextWord(_ text: Substring) -> Bool {
    guard let last = text.last else { return false }
    if self.wordPrefixes.contains(last) { return true }
    if last == "-" { return text.dropLast().last.map { $0.isLetter || $0.isNumber } ?? false }
    if self.isQuote(last) { return self.quotesOpen(atEndOf: text) }
    return self.isOpeningBracket(last)
  }

  private static func quotesOpen(atEndOf text: Substring) -> Bool {
    let runLength = text.reversed().prefix(while: self.isQuote).count
    let rest = text.dropLast(runLength)
    guard let previous = rest.last else { return true }
    if previous.isWhitespace || self.isOpeningBracket(previous) {
      let mark = text[rest.endIndex]
      guard let opener = self.guillemetOpeners[mark] else { return true }
      return rest.count { $0 == opener } <= rest.count { $0 == mark }
    }
    return runLength == 1 && (text.last == "'" || text.last == "’")
      && self.endsWithElidedWord(rest) && !self.hasOpenSingleQuote(rest)
  }

  private static func endsWithElidedWord(_ text: Substring) -> Bool {
    let word = String(text.reversed().prefix(while: \.isLetter).reversed())
    guard
      !word.isEmpty,
      text.dropLast(word.count).last.map({ $0.isWhitespace || self.isOpeningBracket($0) }) ?? true
    else { return false }
    return self.elidedWords.contains(word.lowercased())
  }

  private static func hasOpenSingleQuote(_ text: Substring) -> Bool {
    var isOpen = false
    var previous: Character?
    for index in text.indices {
      let character = text[index]
      defer { previous = character }
      guard character == "‘" || character == "'" || character == "’" else { continue }
      if character == "‘" || previous.map({ $0.isWhitespace || self.isOpeningBracket($0) }) ?? true {
        isOpen = true
      } else if text[text.index(after: index)...].first?.isLetter != true {
        isOpen = false
      }
    }
    return isOpen
  }

  private static func dictationStartsWord(_ text: Substring) -> Bool {
    guard let first = text.first else { return false }
    if self.closingMarks.contains(first) { return false }
    if first == "-" { return text.dropFirst().first.map { $0.isWhitespace || $0.isNumber } ?? true }
    guard self.isQuote(first), !self.openingQuotes.contains(first) else { return true }
    return text.drop(while: self.isQuote).first.map { !$0.isWhitespace && !self.closingMarks.contains($0) } ?? false
  }

  private static func isQuote(_ character: Character) -> Bool {
    character.unicodeScalars.first?.properties.isQuotationMark ?? false
  }

  private static func isOpeningBracket(_ character: Character) -> Bool {
    character.unicodeScalars.first?.properties.generalCategory == .openPunctuation
  }
}
