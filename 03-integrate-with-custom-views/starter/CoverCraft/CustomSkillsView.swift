/// Copyright (c) 2024 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CustomSkillsView: UIView, UITextInput, UIKeyInput {
  // MARK: - Required Properties

  // Text Kit components
  private var textStorage = NSTextStorage()
  private var layoutManager = NSLayoutManager()
  private var textContainer = NSTextContainer()

  // Property to store caret (cursor) position
  private var caretPosition: UITextPositionImpl = UITextPositionImpl(index: 0)

  // Timer for cursor blinking
  private var cursorTimer: Timer?
  private var showCursor: Bool = true // Toggles cursor visibility for blinking effect

  // MARK: - UITextInput Properties
  var selectedTextRange: UITextRange?
  var markedTextRange: UITextRange?
  var markedTextStyle: [NSAttributedString.Key: Any]?
  var inputDelegate: UITextInputDelegate?
  var tokenizer: UITextInputTokenizer = UITextInputStringTokenizer()

  // MARK: - UIView Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupInteraction()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupInteraction()
  }

  // MARK: - Setup Text Interaction
  private func setupInteraction() {
    let textInteraction = UITextInteraction(for: .editable)
    textInteraction.textInput = self
    addInteraction(textInteraction)

    // Set up Text Kit components
    textStorage.addLayoutManager(layoutManager)
    layoutManager.addTextContainer(textContainer)
    textContainer.lineFragmentPadding = 0

    // Enable user interaction and set appearance
    isUserInteractionEnabled = true
    backgroundColor = .white
    layer.borderColor = UIColor.gray.cgColor
    layer.borderWidth = 1

    // Initialize selectedTextRange
    selectedTextRange = UITextRangeImpl(range: NSRange(location: 0, length: 0))

    // Start cursor blinking
    startCursorBlinking()
  }

  override var canBecomeFirstResponder: Bool {
    return true
  }

  // MARK: - Touch Handling Methods

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Become first responder on touch
    becomeFirstResponder()

    // Update caret position based on touch location
    if let touch = touches.first {
      let location = touch.location(in: self)
      if let position = closestPosition(to: location) {
        caretPosition = position as! UITextPositionImpl
        selectedTextRange = UITextRangeImpl(range: NSRange(location: caretPosition.index, length: 0))
        setNeedsDisplay()
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Update selected text range based on touch location
    if let touch = touches.first {
      let location = touch.location(in: self)
      if let position = closestPosition(to: location) {
        if let startPosition = selectedTextRange?.start {
          let newRange = textRange(from: startPosition, to: position)
          selectedTextRange = newRange
          caretPosition = position as! UITextPositionImpl
          setNeedsDisplay()
        }
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Finalize selection or caret position
    if let touch = touches.first {
      let location = touch.location(in: self)
      if let position = closestPosition(to: location) {
        caretPosition = position as! UITextPositionImpl
        selectedTextRange = UITextRangeImpl(range: NSRange(location: caretPosition.index, length: 0))
        setNeedsDisplay()
      }
    }
  }

  private func startCursorBlinking() {
    cursorTimer?.invalidate()
    cursorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
      self?.showCursor.toggle()
      self?.setNeedsDisplay()
    }
  }

  // MARK: - Drawing Methods

  override func draw(_ rect: CGRect) {
    // Update text container size
    textContainer.size = CGSize(width: rect.width - 10, height: rect.height - 10)
    let textOffset = CGPoint(x: 5, y: 5)

    // Draw text
    let glyphRange = layoutManager.glyphRange(for: textContainer)
    layoutManager.drawBackground(forGlyphRange: glyphRange, at: textOffset)
    layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: textOffset)

    // Draw text selection background
    if let selectedRange = selectedTextRange {
      let nsRange = (selectedRange as! UITextRangeImpl).nsRange
      UIColor.orange.withAlphaComponent(0.5).setFill()
      layoutManager.enumerateEnclosingRects(
        forGlyphRange: nsRange,
        withinSelectedGlyphRange: nsRange,
        in: textContainer
      ) { (rect, _) in
        var selectionRect = rect
        selectionRect.origin.x += textOffset.x
        selectionRect.origin.y += textOffset.y
        UIRectFill(selectionRect)
      }
    }

    // Draw caret (cursor)
    if isFirstResponder && showCursor {
      drawCursor()
    }
  }

  private func drawCursor() {
    let textOffset = CGPoint(x: 5, y: 5)
    var caretRect = self.caretRect(for: caretPosition)
    caretRect.origin.x += textOffset.x
    caretRect.origin.y += textOffset.y
    caretRect.size.width = 2 // Set cursor width

    UIColor.blue.setFill()
    UIRectFill(caretRect)
  }

  // MARK: - UIKeyInput Methods

  var hasText: Bool {
    return textStorage.length > 0
  }

  func insertText(_ text: String) {
    // Insert the text at the caret position
    let insertionIndex = caretPosition.index
    textStorage.replaceCharacters(in: NSRange(location: insertionIndex, length: 0), with: text)
    caretPosition.index += text.count

    // Update selected text range
    selectedTextRange = UITextRangeImpl(range: NSRange(location: caretPosition.index, length: 0))

    setNeedsDisplay() // Redraw view
  }

  func deleteBackward() {
    // Delete the character before the caret position
    let deletionIndex = caretPosition.index
    if deletionIndex > 0 {
      textStorage.replaceCharacters(in: NSRange(location: deletionIndex - 1, length: 1), with: "")
      caretPosition.index -= 1

      // Update selectedTextRange
      selectedTextRange = UITextRangeImpl(range: NSRange(location: caretPosition.index, length: 0))

      setNeedsDisplay() // Redraw view
    }
  }

  // MARK: - UITextInput Methods

  func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
    // For simplicity, we won't handle marked text in this example
  }

  func unmarkText() {
    // Unmark the text
  }

  func text(in range: UITextRange) -> String? {
    guard let range = range as? UITextRangeImpl else { return nil }
    return textStorage.attributedSubstring(from: range.nsRange).string
  }

  func replace(_ range: UITextRange, withText text: String) {
    guard let range = range as? UITextRangeImpl else { return }
    textStorage.replaceCharacters(in: range.nsRange, with: text)
    setNeedsDisplay()
  }

  var beginningOfDocument: UITextPosition {
    return UITextPositionImpl(index: 0)
  }

  var endOfDocument: UITextPosition {
    return UITextPositionImpl(index: textStorage.length)
  }

  func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
    guard
      let fromPosition = fromPosition as? UITextPositionImpl,
      let toPosition = toPosition as? UITextPositionImpl
    else {
      return nil
    }
    let start = min(fromPosition.index, toPosition.index)
    let length = abs(toPosition.index - fromPosition.index)
    return UITextRangeImpl(range: NSRange(location: start, length: length))
  }

  func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
    guard let position = position as? UITextPositionImpl else { return nil }
    let newIndex = position.index + offset
    guard newIndex >= 0 && newIndex <= textStorage.length else { return nil }
    return UITextPositionImpl(index: newIndex)
  }

  func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
    guard
      let position = position as? UITextPositionImpl,
      let other = other as? UITextPositionImpl
    else {
      return .orderedSame
    }

    if position.index < other.index {
      return .orderedAscending
    } else if position.index > other.index {
      return .orderedDescending
    } else {
      return .orderedSame
    }
  }

  func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
    guard
      let from = from as? UITextPositionImpl,
      let toPosition = toPosition as? UITextPositionImpl
    else { return 0 }
    return toPosition.index - from.index
  }

  // MARK: - UITextInput Methods for Text Selection and Positioning

  func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
    // Return nil for simplicity
    return nil
  }

  func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
    // Return nil for simplicity
    return nil
  }

  func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? {
    // Return nil for simplicity
    return nil
  }

  func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection {
    // Default to natural writing direction
    return .natural
  }

  func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) {
    // No-op for simplicity
  }

  func firstRect(for range: UITextRange) -> CGRect {
    guard let range = range as? UITextRangeImpl else { return CGRect.zero }
    let glyphRange = layoutManager.glyphRange(forCharacterRange: range.nsRange, actualCharacterRange: nil)
    var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    rect.origin.x += 5
    rect.origin.y += 5
    return rect
  }

  func caretRect(for position: UITextPosition) -> CGRect {
    guard let position = position as? UITextPositionImpl else { return CGRect.zero }
    var index = position.index
    let length = textStorage.length

    if index > length {
      index = length
    }

    if length == 0 {
      // Handle the empty text case
      let defaultHeight: CGFloat = UIFont.systemFont(ofSize: 16).lineHeight
      return CGRect(x: 0, y: 0, width: 2, height: defaultHeight)
    } else if index == length {
      // Handle caret at the end of the text
      let lastGlyphIndex = layoutManager.glyphIndexForCharacter(at: length - 1)
      let lastGlyphLocation = layoutManager.location(forGlyphAt: lastGlyphIndex)
      let lastGlyphWidth = layoutManager.attachmentSize(forGlyphAt: lastGlyphIndex).width
      let lineRect = layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex, effectiveRange: nil)
      return CGRect(x: lastGlyphLocation.x + lastGlyphWidth, y: lineRect.minY, width: 2, height: lineRect.height)
    } else {
      let glyphIndex = layoutManager.glyphIndexForCharacter(at: index)
      let glyphLocation = layoutManager.location(forGlyphAt: glyphIndex)
      let lineRect = layoutManager.lineFragmentUsedRect(forGlyphAt: glyphIndex, effectiveRange: nil)
      return CGRect(x: glyphLocation.x, y: lineRect.minY, width: 2, height: lineRect.height)
    }
  }

  func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
    // Return an empty array for simplicity
    return []
  }

  func closestPosition(to point: CGPoint) -> UITextPosition? {
    let location = CGPoint(x: point.x - 5, y: point.y - 5)
    let index = layoutManager.characterIndex(
      for: location,
      in: textContainer,
      fractionOfDistanceBetweenInsertionPoints: nil
    )
    return UITextPositionImpl(index: index)
  }

  func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
    // Return nil for simplicity
    return nil
  }

  func characterRange(at point: CGPoint) -> UITextRange? {
    // Return nil for simplicity
    return nil
  }

  deinit {
    cursorTimer?.invalidate()
  }
}

// MARK: - Helper Classes for UITextPosition and UITextRange

class UITextPositionImpl: UITextPosition {
  var index: Int

  init(index: Int) {
    self.index = index
  }
}

class UITextRangeImpl: UITextRange {
  var nsRange: NSRange

  init(range: NSRange) {
    self.nsRange = range
  }

  override var isEmpty: Bool {
    return nsRange.length == 0
  }

  override var start: UITextPosition {
    return UITextPositionImpl(index: nsRange.location)
  }

  override var end: UITextPosition {
    return UITextPositionImpl(index: nsRange.location + nsRange.length)
  }
}
