
import UIKit

extension KeyboardViewController {

  @discardableResult
  func insertSpacedText(_ text: String) -> (leading: String, trailing: String) {
    let proxy = textDocumentProxy
    let isAddressField = proxy.keyboardType == .URL || proxy.keyboardType == .emailAddress
    let separators = DictationSpacing.separators(
      for: text,
      before: proxy.documentContextBeforeInput,
      after: proxy.documentContextAfterInput,
      isAddressField: isAddressField,
    )
    proxy.insertText(separators.leading + text + separators.trailing)
    self.previousSpaceTap = nil
    return separators
  }

  func insertSpace() {
    let proxy = textDocumentProxy
    let uptime = ProcessInfo.processInfo.systemUptime
    let before = proxy.documentContextBeforeInput
    let after = proxy.documentContextAfterInput
    if
      SharedSettings().periodShortcutEnabled,
      proxy.selectedText?.isEmpty ?? true,
      let replacement = PeriodShortcut.replacement(
        before: before,
        after: after,
        uptime: uptime,
        previousTap: self.previousSpaceTap,
      )
    {
      proxy.deleteBackward()
      proxy.insertText(replacement)
      self.previousSpaceTap = nil
    } else {
      proxy.insertText(" ")
      self.previousSpaceTap = PeriodShortcut.Tap(uptime: uptime, before: before, after: after)
    }
  }
}
