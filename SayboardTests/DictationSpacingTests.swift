import Testing

@Suite("DictationSpacing")
struct DictationSpacingTests {

  @Test
  func `a dictation after a sentence gets a space`() {
    #expect(Self.insertion("For", before: "save.") == " For")
  }

  @Test
  func `a dictation after a word gets a space`() {
    #expect(Self.insertion("Next", before: "word") == " Next")
  }

  @Test
  func `the first dictation in a field gets no space`() {
    #expect(Self.insertion("Hello", before: nil) == "Hello")
    #expect(Self.insertion("Hello", before: "") == "Hello")
  }

  @Test
  func `no space after a space, a no-break space or a new line`() {
    #expect(Self.insertion("Next", before: "word ") == "Next")
    #expect(Self.insertion("Next", before: "word\u{A0}") == "Next")
    #expect(Self.insertion("Next", before: "line\n") == "Next")
  }

  @Test
  func `no space after an opening bracket`() {
    #expect(Self.insertion("note", before: "see (") == "note")
  }

  @Test
  func `a quote after a space opens and a quote after a word closes`() {
    #expect(Self.insertion("hello", before: "He said \"") == "hello")
    #expect(Self.insertion("Next", before: "He said \"hi\"") == " Next")
    #expect(Self.insertion("Hallo", before: "Er sagte „") == "Hallo")
    #expect(Self.insertion("Next", before: "Er sagte „Hallo“") == " Next")
  }

  @Test
  func `a French closing guillemet after a space closes`() {
    #expect(Self.insertion("Bonjour", before: "Il a dit «") == "Bonjour")
    #expect(Self.insertion("Ensuite", before: "Il a dit « Bonjour\u{A0}»") == " Ensuite")
    #expect(Self.insertion("Ensuite", before: "Il a dit « Bonjour »") == " Ensuite")
  }

  @Test
  func `quotes in Danish open with » and close with «`() {
    #expect(Self.insertion("Hej", before: "Han sagde »") == "Hej")
    #expect(Self.insertion("sagde han", before: "»Hej«") == " sagde han")
  }

  @Test
  func `nested closing quotes close`() {
    #expect(Self.insertion("Then", before: "He said “she said ‘no’”") == " Then")
    #expect(Self.insertion("Then", before: "He said \"she said 'no'\"") == " Then")
    #expect(Self.insertion("Dann", before: "Er sagte „sie sagte ‚nein‘“") == " Dann")
    #expect(Self.insertion("Then", before: "“well-”") == " Then")
  }

  @Test
  func `a dictation that starts with an opening quote or apostrophe gets a space`() {
    #expect(Self.insertion("”Hej”, sa hon.", before: "Han sa:") == " ”Hej”, sa hon.")
    #expect(Self.insertion("»Hej«, sagde hun.", before: "Han sagde:") == " »Hej«, sagde hun.")
    #expect(Self.insertion("’s avonds", before: "Hij komt") == " ’s avonds")
    #expect(Self.insertion("’90s were great", before: "The") == " ’90s were great")
    #expect(Self.insertion("\"¿Vienes mañana?\"", before: "Le pregunté:") == " \"¿Vienes mañana?\"")
    #expect(Self.insertion("“¡Cuidado!”", before: "Gritó:") == " “¡Cuidado!”")
  }

  @Test
  func `a dictation that starts with a closing quote gets no space`() {
    #expect(Self.insertion("” she said", before: "“Hi") == "” she said")
  }

  @Test
  func `no space after a handle, hashtag or slash sign`() {
    #expect(Self.insertion("stan", before: "ping @") == "stan")
    #expect(Self.insertion("tag", before: "#") == "tag")
    #expect(Self.insertion("or", before: "and/") == "or")
  }

  @Test
  func `a hyphen attaches only after a letter or digit`() {
    #expect(Self.insertion("known", before: "well-") == "known")
    #expect(Self.insertion("20", before: "10-") == "20")
    #expect(Self.insertion("aber", before: "Das ist gut -") == " aber")
    #expect(Self.insertion("milk", before: "List:\n-") == " milk")
  }

  @Test
  func `a minus before a number starts a word, except right after a number`() {
    #expect(Self.insertion("-5 degrees today.", before: "The temperature is") == " -5 degrees today.")
    #expect(Self.insertion("-20", before: "Pages 10") == "-20")
    #expect(Self.insertion("price", before: "The ", after: "-5% off") == "price ")
  }

  @Test
  func `a currency or plus sign attaches to a number only`() {
    #expect(Self.insertion("50", before: "It costs $") == "50")
    #expect(Self.insertion("49 30 1234", before: "Call +") == "49 30 1234")
    #expect(Self.insertion("Ensuite", before: "Ça coûte 50 $") == " Ensuite")
    #expect(Self.insertion("Next", before: "It costs 50 €") == " Next")
    #expect(Self.insertion("20 Stück kosten mehr.", before: "Das kostet 50 €") == " 20 Stück kosten mehr.")
  }

  @Test
  func `an elided French or Italian word attaches to the next word`() {
    #expect(Self.insertion("homme", before: "J'aime l'") == "homme")
    #expect(Self.insertion("idée de Paul", before: "C’est l’") == "idée de Paul")
    #expect(Self.insertion("ici", before: "jusqu'") == "ici")
    #expect(Self.insertion("amica", before: "È un'") == "amica")
  }

  @Test
  func `a possessive or a closed single quote still gets a space`() {
    #expect(Self.insertion("books", before: "the students’") == " books")
    #expect(Self.insertion("roll", before: "rock 'n'") == " roll")
    #expect(Self.insertion("and left.", before: "She said ‘that’s all’") == " and left.")
    #expect(Self.insertion("daily.", before: "He takes ‘vitamin C’") == " daily.")
  }

  @Test
  func `inverted Spanish marks attach to the following word`() {
    #expect(Self.insertion("Qué tal?", before: "Hola. ¿") == "Qué tal?")
    #expect(Self.insertion("Hola", before: "Dijo: ¡") == "Hola")
    #expect(Self.insertion("¿Qué tal?", before: "Hola.") == " ¿Qué tal?")
    #expect(Self.insertion("¡Hola!", before: "Dijo:") == " ¡Hola!")
  }

  @Test
  func `no space before closing punctuation`() {
    #expect(Self.insertion(".com", before: "example") == ".com")
    #expect(Self.insertion(", and then", before: "first") == ", and then")
  }

  @Test
  func `text in Japanese and Chinese joins without a space`() {
    #expect(Self.insertion("明日も晴れです。", before: "今日は晴れです。") == "明日も晴れです。")
    #expect(Self.insertion("我很好", before: "你好。") == "我很好")
    #expect(Self.insertion("今日は", before: nil, after: "晴れ") == "今日は")
  }

  @Test
  func `text in Korean, Hindi and Arabic keeps the space`() {
    #expect(Self.insertion("저는 학생입니다", before: "안녕하세요.") == " 저는 학생입니다")
    #expect(Self.insertion("आप कैसे हैं", before: "नमस्ते।") == " आप कैसे हैं")
    #expect(Self.insertion("كيف حالك", before: "مرحبا.") == " كيف حالك")
  }

  @Test
  func `an emoji before the cursor still gets a space`() {
    #expect(Self.insertion("Next", before: "Great 😀") == " Next")
  }

  @Test
  func `a dictation in front of a word or an opening sign gets a trailing space`() {
    #expect(Self.insertion("big", before: "Hello ", after: "world") == "big ")
    #expect(Self.insertion("about", before: "It costs ", after: "$50") == "about ")
    #expect(Self.insertion("this", before: "Check ", after: "#news") == "this ")
    #expect(Self.insertion("more", before: "See ", after: "(above)") == "more ")
  }

  @Test
  func `no trailing space before a quotation mark, which may close a quote or begin ’s`() {
    #expect(Self.insertion("Jake", before: "I borrowed ", after: "’s car.") == "Jake")
    #expect(Self.insertion("She", before: "", after: "'ll be there") == "She")
    #expect(Self.insertion("verden", before: "»Hej", after: "«") == " verden")
    #expect(Self.insertion("loudly", before: "He said ", after: "“hi”") == "loudly")
    #expect(Self.insertion("fort", before: "Il a dit ", after: "« oui »") == "fort")
  }

  @Test
  func `no trailing space at the end of the text or before punctuation or a space`() {
    #expect(Self.insertion("there", before: "Hello ", after: nil) == "there")
    #expect(Self.insertion("there", before: "Hello ", after: "") == "there")
    #expect(Self.insertion("there", before: "Hello ", after: ".") == "there")
    #expect(Self.insertion("there", before: "Hello ", after: " friend") == "there")
  }

  @Test
  func `no trailing space before a closing quote or a suffix`() {
    #expect(Self.insertion("world", before: "\"hello ", after: "\"") == "world")
    #expect(Self.insertion("cloud", before: "a ", after: "-based app") == "cloud")
  }

  @Test
  func `an address field gets no spaces`() {
    #expect(Self.insertion("example", before: "name@mail", after: "com", isAddressField: true) == "example")
    #expect(Self.insertion("path", before: "example.com", isAddressField: true) == "path")
  }

  private static func insertion(
    _ text: String,
    before: String?,
    after: String? = nil,
    isAddressField: Bool = false,
  ) -> String {
    let separators = DictationSpacing.separators(
      for: text,
      before: before,
      after: after,
      isAddressField: isAddressField,
    )
    return separators.leading + text + separators.trailing
  }
}
