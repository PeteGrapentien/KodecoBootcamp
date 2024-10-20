import SwiftUI
import PhotosUI
import Vision

struct ContentView: View {
  @State private var selectedImage: PhotosPickerItem?
  @State private var image: Image?
  @State private var cgImage: CGImage?
  @State private var detectedObjects: [DetectedObject] = []

  func runModel() {
    guard
      // 1
      let cgImage = cgImage,
      // 2
      // NOTE: you will need to import the model files in Lesson 3, Instruction 1 for this project to compile. We aren't included
      let model = try? yolov8x_oiv7(configuration: .init()).model,
      // 3
      let detector = try? VNCoreMLModel(for: model) else {
        // 4
        print("Unable to load photo.")
        return
    }
    // 1
    let visionRequest = VNCoreMLRequest(model: detector) { request, error in
      detectedObjects = []
      if let error = error {
        print(error.localizedDescription)
        return
      }
      // 2
      if let results = request.results as? [VNRecognizedObjectObservation] {
        // 1
        if results.isEmpty {
          print("No results found.")
          return
        }
        // 2
        for result in results {
          // 3
          if let firstIdentifier = result.labels.first {
            let confidence = firstIdentifier.confidence
            let label = firstIdentifier.identifier
            // 4
            let boundingBox = result.boundingBox
            // 5
            let object = DetectedObject(
              label: label,
              confidence: confidence,
              boundingBox: boundingBox
            )
            detectedObjects.append(object)
          }
        }
      }
    }
    // 1
    visionRequest.imageCropAndScaleOption = .scaleFill
    // 2
    let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
    // 3
    do {
      try handler.perform([visionRequest])
    } catch {
      print(error)
    }
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
