import SwiftUI
import PhotosUI
import Vision

struct ContentView: View {
  @State private var selectedImage: PhotosPickerItem?
  @State private var image: Image?
  @State private var cgImage: CGImage?
  @State private var detectedObjects: [DetectedObject] = []

  func runModel() {
      
  }
  
  var body: some View {
    PhotosPicker("Select Photo", selection: $selectedImage, matching: .images)
      .onChange(of: selectedImage) {
        Task {
          if
            let loadedImageData = try? await selectedImage?.loadTransferable(type: Data.self),
            let uiImage = UIImage(data: loadedImageData) {
            image = Image(uiImage: uiImage)
            cgImage = uiImage.cgImage
          }
        }
      }
      .onChange(of: cgImage) {
        runModel()
      }
    if let image = image {
      ImageDisplayView(image: image)
        .overlay {
          ForEach(detectedObjects, id: \.self) { ident in
            `ObjectOverlayView`(object: ident)
          }
        }
    } else {
      NoImageSelectedView()
    }
    ForEach(detectedObjects, id: \.self) { obj in
      Text(obj.label) + Text(" (") + Text(obj.confidence, format: .percent) + Text(")")
    }
  }
}

#Preview {
  ContentView()
}
