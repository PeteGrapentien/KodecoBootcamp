//
//  Pet_DetectorApp.swift
//  Pet-Detector
//
//  Created by Peter Grapentien on 10/8/24.
//

import SwiftUI
import PhotosUI

@main
struct Pet_DetectorApp: App {
  @StateObject private var photoPickerViewModel = PhotoPickerViewModel()
  var body: some Scene {
    WindowGroup {
      NavigationView {
        TabView {
            PetView(viewModel: .init(photoPickerViewModel: photoPickerViewModel))
        }.navigationTitle("Pet Identification")
          .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              PhotosPicker(
                selection: $photoPickerViewModel.imageSelection,
                matching: .images,
                photoLibrary: .shared()
              ) {
                Image(systemName: "photo.on.rectangle.angled")
                  .imageScale(.large)
              }
            }
          }
      }
    }
  }
}

