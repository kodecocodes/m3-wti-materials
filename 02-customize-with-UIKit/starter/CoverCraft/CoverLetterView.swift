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

import SwiftUI

struct CoverLetterView: View {
  @State private var coverLetterText: String = "Dear Hiring Manager,\n\n"
  private var coverLetterManager = CoverLetterManager.shared
  @State private var coverLetter = CoverLetter(title: "Awesome Cover Letter", content: "Dear Hiring Manager,\n\n")
  @State private var showingSavedDrafts = false
  @State private var draftTitle: String = "Awesome Cover Letter"
  @State private var showingSaveAlert: Bool = false
  var body: some View {
    VStack {
      Text("Cover Letter Creator")
        .font(.title)
        .padding()
      TextEditor(text: $coverLetterText)
        .writingToolsBehavior(WritingToolsBehavior.complete)
        .scrollContentBackground(.hidden)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(8)
        .frame(height: 300)
        .padding(.horizontal)
      HStack {
        Button(action: {
          showingSaveAlert = true
        }, label: {
          Text("Save New Draft")
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        })
        .alert("Save Draft", isPresented: $showingSaveAlert) {
          TextField("Enter draft name", text: $draftTitle)
          Button("Save", action: saveCoverLetter)
          Button("Cancel", role: .cancel, action: {})
        } message: {
          Text("Please enter a name for your draft.")
        }
        Button(action: {
          showingSavedDrafts = true
        }, label: {
          Text("Load Saved Draft")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        })
        .sheet(isPresented: $showingSavedDrafts) {
          SavedDraftsView(onSelect: loadSavedDraft)
        }
      }
      .padding()
    }
    .padding()
  }
  func saveCoverLetter() {
    guard !draftTitle.isEmpty else { return }
    let newCoverLetter = CoverLetter(title: draftTitle, content: coverLetterText)
    coverLetterManager.saveCoverLetter(newCoverLetter)
    draftTitle = ""
  }
  func loadSavedDraft(_ selectedCoverLetter: CoverLetter) {
    coverLetterText = selectedCoverLetter.content
    coverLetter = selectedCoverLetter
  }
  func deleteCoverLetter(at offsets: IndexSet) {
    offsets.map { coverLetterManager.coverLetters[$0] }.forEach(coverLetterManager.deleteCoverLetter)
  }
}

#Preview {
  CoverLetterView()
}
