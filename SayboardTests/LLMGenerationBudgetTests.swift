import Testing

@testable import Sayboard

@Suite("Prompt admission and the generation budget")
struct LLMGenerationBudgetTests {

  @Test
  func `a prompt that fills exactly one batch is admitted`() {
    #expect(Self.budget(promptTokens: 512) == 496)
  }

  @Test
  func `one token past the batch is refused`() {
    #expect(Self.budget(promptTokens: 513) == nil)
  }

  @Test
  func `the budget is whatever the window has left`() {
    #expect(Self.budget(promptTokens: 100) == 908)
  }

  @Test
  func `a prompt that leaves the window no room is refused`() {
    let budget = LLMInferenceService.generationBudget(promptTokens: 500, batchSize: Self.batchSize, contextSize: 516)
    #expect(budget == nil)
  }

  private static let batchSize = 512
  private static let contextSize = 1024

  private static func budget(promptTokens: Int) -> Int? {
    LLMInferenceService.generationBudget(
      promptTokens: promptTokens,
      batchSize: self.batchSize,
      contextSize: self.contextSize,
    )
  }
}
