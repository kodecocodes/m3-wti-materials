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
    
    var body: some View {
        VStack {
            Text("Cover Letter Creator")
                .font(.title)
                .padding()
            
            // MARK: - Lesson Two or Three
            
            // CustomTextView(text: $coverLetterText)
            
            // MARK: - Lesson One
            
            // for Lesson One, we'll use the SwiftUI view and show how one can use the writingToolsBehavior view modifier to control which version of the tools displays
            
            TextEditor(text: $coverLetterText)
                .writingToolsBehavior(WritingToolsBehavior.complete)
                .scrollContentBackground(.hidden)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(8)
                .frame(height: 300)
                .padding(.horizontal)
            
            Button(action: generateCoverLetter) {
                Text("Create Cover Letter")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    func generateCoverLetter() {
        // This is where you would integrate Writing Tools to generate the cover letter
        // WritingTools.proofread(text: coverLetterText) { suggestions in
        //     applySuggestions(suggestions)
        // }
        print("Generate cover letter with Writing Tools")
    }
}


#Preview {
    CoverLetterView()
}
