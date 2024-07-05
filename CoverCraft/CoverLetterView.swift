//
//  CoverLetterView.swift
//  CoverCraft
//
//  Created by Susannah Skyer Gupta on 7/5/24.
//

import SwiftUI

struct CoverLetterView: View {
    @State private var coverLetterText: String = "Dear Hiring Manager,\n\n"

    var body: some View {
        VStack {
            Text("Cover Letter Generator")
                .font(.title)
                .padding()

            CustomTextView(text: $coverLetterText)
                .frame(height: 300)
                .padding()

            Button(action: generateCoverLetter) {
                Text("Generate Cover Letter")
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
