//
//  JobPostingView.swift
//  CoverCraft
//
//  Created by Susannah Skyer Gupta on 7/5/24.
//

import SwiftUI
import WebKit

struct JobPostingView: View {
    @State private var urlString: String = ""
    @State private var showWebView: Bool = false

    var body: some View {
        VStack {
            TextField("Enter Job Posting URL", text: $urlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                showWebView = true
            }) {
                Text("Open Job Posting")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if showWebView {
                WebView(urlString: urlString)
                    .frame(height: 400)
            }
        }
        .padding()
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}


#Preview {
    JobPostingView()
}
