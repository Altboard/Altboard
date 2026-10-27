import Foundation
import Testing

@Suite("PeriodShortcut")
struct PeriodShortcutTests {

  @Test
  func `a quick second space after a word ends the sentence`() {
    #expect(Self.replacement(before: "Hello ") == ". ")
  }

  @Test
  func `the second space counts up to 1.2 seconds after the first`() {
    #expect(Self.replacement(before: "Hello ", seconds: 1.2) == ". ")
    #expect(Self.replacement(before: "Hello ", seconds: 1.3) == nil)
    #expect(PeriodShortcut.replacement(before: "Hello ", after: nil, uptime: 1, previousTap: nil) == nil)
  }

  @Test
  func `no period once the caret has moved since the first space`() {
    let tap = PeriodShortcut.Tap(uptime: 100, before: "Hello", after: "world")
    #expect(PeriodShortcut.replacement(before: "foo ", after: "world", uptime: 100.3, previousTap: tap) == nil)
    #expect(PeriodShortcut.replacement(before: "Hello ", after: "", uptime: 100.3, previousTap: tap) == nil)
    #expect(PeriodShortcut.replacement(before: "Hello ", after: "world", uptime: 100.3, previousTap: tap) == ". ")
  }

  @Test(arguments: ["end. ", "Really? ", "Wow! ", "first, ", "note: ", "list; ", "well- ", "Wait— ", "Wait… "])
  func `no period after sentence punctuation, a comma or a dash`(before: String) {
    #expect(Self.replacement(before: before) == nil)
  }

  @Test(arguments: [
    "He said “Stop.” ",
    "He said \"Stop.\" ",
    "He asked ‘Why?’ ",
    "Er sagte „Stopp.“ ",
    "Он сказал «Стоп.» ",
    "Il a dit « Stop. » ",
    "Han sagde »Stop.« ",
    "「止まれ。」 ",
  ])
  func `no period after a quote that closes a sentence`(before: String) {
    #expect(Self.replacement(before: before) == nil)
  }

  @Test(arguments: ["Il a dit « oui » ", "Он сказал «да» "])
  func `a period goes after a closing guillemet when the quote ends no sentence`(before: String) {
    #expect(Self.replacement(before: before) == ". ")
  }

  @Test
  func `no period at the start of the text or after two spaces or a new line`() {
    #expect(Self.replacement(before: nil) == nil)
    #expect(Self.replacement(before: " ") == nil)
    #expect(Self.replacement(before: "Hello  ") == nil)
    #expect(Self.replacement(before: "Hello\n ") == nil)
  }

  @Test
  func `no period once the first space is no longer before the cursor`() {
    #expect(Self.replacement(before: "Hello") == nil)
  }

  @Test(arguments: ["Room 5 ", "Great 😀 ", "(see above) ", "He said “hi” ", "Привет ", "Γεια ", "안녕하세요 ", "مرحبا "])
  func `digits, emoji, closing marks and other alphabets end a sentence with a period`(before: String) {
    #expect(Self.replacement(before: before) == ". ")
  }

  @Test(arguments: ["你好 ", "こんにちは ", "他说“你好” "])
  func `a sentence in Chinese or Japanese ends with an ideographic full stop`(before: String) {
    #expect(Self.replacement(before: before) == "。")
  }

  @Test(arguments: ["नमस्ते ", "আমি ভালো আছি ", "ਮੈਂ ਠੀਕ ਹਾਂ "])
  func `a sentence in Hindi, Bengali or Punjabi ends with a danda`(before: String) {
    #expect(Self.replacement(before: before) == "। ")
  }

  @Test(arguments: [
    "你好。 ",
    "你好、 ",
    "你好！ ",
    "你好， ",
    "你好？ ",
    "ﾃｽﾄ｡ ",
    "नमस्ते। ",
    "كيف حالك؟ ",
    "مرحبا، ",
    "مرحبا؛ ",
    "یہ ٹھیک ہے۔ ",
    "Բարեւ։ ",
    "ሰላም። ",
    "Ναι\u{0387} ",
  ])
  func `no period after a full stop, comma or question mark in another script`(before: String) {
    #expect(Self.replacement(before: before) == nil)
  }

  @Test(arguments: ["สวัสดี ", "ສະບາຍດີ ", "བཀྲ་ཤིས་ ", "မင်္ဂလာပါ ", "សួស្តី "])
  func `text in Thai, Lao, Tibetan, Myanmar or Khmer keeps the second space`(before: String) {
    #expect(Self.replacement(before: before) == nil)
  }

  private static func replacement(before: String?, seconds: TimeInterval = 0.3) -> String? {
    let tap = PeriodShortcut.Tap(uptime: 0, before: before.map { String($0.dropLast()) }, after: nil)
    return PeriodShortcut.replacement(before: before, after: nil, uptime: seconds, previousTap: tap)
  }
}
