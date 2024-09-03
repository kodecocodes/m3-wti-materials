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

import Foundation
import Observation

@Observable
class CoverLetterManager {
  static let shared = CoverLetterManager()
  private(set) var coverLetters: [CoverLetter] = []
  private let storageURL: URL
  private init() {
    let fileManager = FileManager.default
    guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      fatalError("Could not locate document directory.")
    }
    storageURL = documentsURL.appendingPathComponent("CoverLetters.plist")
    loadCoverLetters()
  }
  private func loadCoverLetters() {
    do {
      let data = try Data(contentsOf: storageURL)
      let decoder = PropertyListDecoder()
      coverLetters = try decoder.decode([CoverLetter].self, from: data)
    } catch {
      print("Failed to load cover letters: \(error)")
    }
  }
  func saveCoverLetter(_ coverLetter: CoverLetter) {
    if let index = coverLetters.firstIndex(where: { $0.id == coverLetter.id }) {
      coverLetters[index] = coverLetter
    } else {
      coverLetters.append(coverLetter)
    }
    saveToDisk()
  }
  
  private func saveToDisk() {
    do {
      let encoder = PropertyListEncoder()
      let data = try encoder.encode(coverLetters)
      try data.write(to: storageURL)
    } catch {
      print("Failed to save cover letters: \(error)")
    }
  }
  
  func deleteCoverLetter(_ coverLetter: CoverLetter) {
    coverLetters.removeAll { $0.id == coverLetter.id }
    saveToDisk()
  }
}
