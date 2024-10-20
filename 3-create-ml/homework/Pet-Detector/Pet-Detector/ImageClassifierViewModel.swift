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
import Combine
import Vision
import OSLog

@MainActor
class ImageClassifierViewModel: ObservableObject {
    // Shared PhotoPickerViewModel
    @Published var photoPickerViewModel: PhotoPickerViewModel
    @Published var errorMessage: String? = nil
    
    private var petIdentifier = PetIdentifier()
    private var petImage: UIImage?
    
    @State var petPrediction: String = "No value"
    @State var accuracy: String = "0.0"
  
    init(photoPickerViewModel: PhotoPickerViewModel) {
        self.photoPickerViewModel = photoPickerViewModel
        self.petImage = photoPickerViewModel.selectedPhoto?.image
    }
    
    func setImage(newImage: UIImage) {
        self.petImage = newImage
    }
    
    func identifyPet() -> [String: String] {
        var predictionDictionary = [String: String]()
        if let image = self.petImage {
            let resizedImage = resizeImage(image)
            DispatchQueue.global(qos: .userInteractive).async {
              self.petIdentifier.classify(image: resizedImage ?? image) { [weak self] prediction, confidence in
//                  self?.petPrediction = prediction ?? "Failed to set prediction"
                  var conf = confidence ?? -1
//                  self?.accuracy = String(conf)
                  predictionDictionary["prediction"] = prediction
                  predictionDictionary["accuracy"] = String(conf)
              }
            }
        }
        return predictionDictionary
    }
    
    func reset() {
      DispatchQueue.main.async {
        self.petImage = nil
        self.petPrediction = ""
        self.accuracy = ""
      }
    }
    
    private func resizeImage(_ image: UIImage) -> UIImage? {
      UIGraphicsBeginImageContext(CGSize(width: 224, height: 224))
      image.draw(in: CGRect(x: 0, y: 0, width: 224, height: 224))
      let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return resizedImage
    }
}
