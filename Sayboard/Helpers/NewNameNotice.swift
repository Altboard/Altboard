
import Foundation

struct NewNameNotice {

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  var isDue: Bool {
    self.defaults.bool(forKey: SharedKey.hasCompletedOnboarding) && !self.defaults.bool(forKey: Self.doneKey)
  }

  func settleAtLaunch() {
    guard !self.defaults.bool(forKey: SharedKey.hasCompletedOnboarding) else { return }
    self.markDone()
  }

  func markDone() {
    self.defaults.set(true, forKey: Self.doneKey)
  }

  private static let doneKey = "newNameNoticeDone"

  private let defaults: UserDefaults
}
