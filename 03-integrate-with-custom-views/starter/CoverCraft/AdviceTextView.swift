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

class AdviceTextView: UIView, UITextSelectionDisplayInteractionDelegate, UIEditMenuInteractionDelegate {
  private let textView: UITextView
  private var textSelectionInteraction: UITextSelectionDisplayInteraction?
  private var editMenuInteraction: UIEditMenuInteraction?

  private let adviceText = """
    When developing a list of job skills, start by reviewing the job description closely and identifying the key skills mentioned by the employer. Next, think about your past experiences—both professional and personal—and note any skills you've developed that align with these requirements. Be specific and focus on practical skills that are directly relevant to the job you're applying for. Consider dividing your skills into categories such as technical, interpersonal, and problem-solving skills. Highlight skills that demonstrate your ability to adapt, learn, and handle challenges effectively. Finally, use action verbs and quantifiable examples to illustrate your proficiency in these areas, and prioritize the most critical skills for the position at the top of your list.
    """

  override init(frame: CGRect) {
    // Initialize the UITextView with the advice text
    textView = UITextView()
    textView.text = adviceText
    textView.isEditable = false // Disable editing
    textView.isSelectable = true // Enable text selection

    super.init(frame: frame)

    // Initialize interactions with self as delegate
    textSelectionInteraction = UITextSelectionDisplayInteraction(
      textInput: textView,
      delegate: self
    )
    editMenuInteraction = UIEditMenuInteraction(delegate: self)

    // Configure view
    addSubview(textView)
    textView.frame = bounds
    textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    // Add interactions
    if let textSelectionInteraction = textSelectionInteraction {
      addInteraction(textSelectionInteraction)
    }
    if let editMenuInteraction = editMenuInteraction {
      addInteraction(editMenuInteraction)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Implement delegate methods if needed
  // Example: Handling edit menu actions
  func editMenuInteraction(_ interaction: UIEditMenuInteraction, configurationForMenuAtLocation location: CGPoint, suggestedActions: [UIMenuElement]) -> UIMenu? {
    // Customize the menu or return nil to use the default menu
    return UIMenu(children: suggestedActions)
  }

  // Example: UITextSelectionDisplayInteractionDelegate method
  func selectionDisplayInteraction(_ interaction: UITextSelectionDisplayInteraction, willBeginSelectingAt point: CGPoint) {
    // Implement if needed
  }
}
