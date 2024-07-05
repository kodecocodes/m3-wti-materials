//
//  ContentView.swift
//  CoverCraft
//
//  Created by Susannah Skyer Gupta on 7/5/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(destination: CoverLetterView()) {
          Text("Generate Cover Letter")
        }
        NavigationLink(destination: SkillsView()) {
          Text("Define Your Skills")
        }
        NavigationLink(destination: JobPostingView()) {
          Text("Learn More About an Opportunity")
        }
      }
      .navigationTitle("Writing Tools Sample App")
    }
  }
}

#Preview {
  ContentView()
}
