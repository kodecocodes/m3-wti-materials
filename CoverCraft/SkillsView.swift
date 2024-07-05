//
//  SkillsView.swift
//  CoverCraft
//
//  Created by Susannah Skyer Gupta on 7/5/24.
//

import SwiftUI

struct SkillsView: View {
    @State private var skills: String = ""

    var body: some View {
        VStack {
            Text("Define Your Skills")
                .font(.title)
                .padding()

            TextEditor(text: $skills)
                .frame(height: 200)
                .border(Color.gray, width: 1)
                .padding()

            Button(action: saveSkills) {
                Text("Save Skills")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    func saveSkills() {
        // Logic to save skills
        print("Skills saved: \(skills)")
    }
}


#Preview {
    SkillsView()
}
