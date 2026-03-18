import SwiftUI
import PhotosUI

@MainActor
final class UploadViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var caption: String = ""
    @Published var selectedKnotType: KnotType?
    @Published var showSuccessAlert: Bool = false

    static let maxCaptionLength = 100

    var canSubmit: Bool {
        selectedImage != nil && selectedKnotType != nil
    }

    func loadImage() async {
        guard let item = selectedItem else {
            selectedImage = nil
            return
        }
        if let data = try? await item.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
            selectedImage = uiImage
        }
    }

    func enforceMaxCaption() {
        if caption.count > Self.maxCaptionLength {
            caption = String(caption.prefix(Self.maxCaptionLength))
        }
    }

    func submit() {
        // Dummy success — in production, upload to Supabase Storage + DB
        showSuccessAlert = true
        resetForm()
    }

    private func resetForm() {
        selectedItem = nil
        selectedImage = nil
        caption = ""
        selectedKnotType = nil
    }
}
