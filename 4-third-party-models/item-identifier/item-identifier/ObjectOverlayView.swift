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
import Vision

struct ObjectOverlayView: View {
  var object: DetectedObject
  var lineColor: Color = .red

  var body: some View {
    GeometryReader { proxy in
      let adjustedRect = VNImageRectForNormalizedRect(
        object.boundingBox,
        Int(proxy.size.width),
        Int(proxy.size.height)
      )

      let xa1 = adjustedRect.origin.x
      let ya1 = proxy.size.height - adjustedRect.origin.y
      let xa2 = adjustedRect.origin.x + adjustedRect.width
      let ya2 = proxy.size.height - (adjustedRect.origin.y + adjustedRect.height)
      Path { path in
        path.move(to: .init(x: xa1, y: ya1))
        path.addLine(to: .init(x: xa1, y: ya2))
        path.addLine(to: .init(x: xa2, y: ya2))
        path.addLine(to: .init(x: xa2, y: ya1))
        path.closeSubpath()
      }
      .stroke(lineColor, lineWidth: 2.0)
      let textX = min(xa1, xa2)
      let textY = min(ya1, ya2)
      Text(object.label)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
        .offset(x: textX, y: textY)
        .padding(2.0)
    }  }
}

#Preview {
  let object = DetectedObject(
    label: "test",
    confidence: 0.3521,
    boundingBox: CGRect(x: 0.2, y: 0.3, width: 0.1, height: 0.1)
  )
  ObjectOverlayView(object: object)
}
