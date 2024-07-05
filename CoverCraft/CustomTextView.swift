//
//  CustomTextView.swift
//  CoverCraft
//
//  Created by Susannah Skyer Gupta on 7/5/24.
//

import SwiftUI
import UIKit

struct CustomTextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1)

        // Setup for TextKit 2
        // textView.textStorage = NSTextStorage()
        // let layoutManager = NSLayoutManager()
        // let textContainer = NSTextContainer(size: CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        // layoutManager.addTextContainer(textContainer)
        // textView.textContainer = textContainer
        // textView.textStorage.addLayoutManager(layoutManager)

        textView.text = text
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextView

        init(_ parent: CustomTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}


#Preview {
    CustomTextView(text: .constant("Sample Text"))
}
