import SwiftUI
import PhotosUI

@MainActor
final class UploadViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var caption: String = ""
    @Published var selectedKnotType: KnotType?
    @Published var showSuccessAlert: Bool = false
    @Published var isSubmitting: Bool = false
    @Published var errorMessage: String?

    private let repository: PostRepository

    static let maxCaptionLength = 100

    init(repository: PostRepository = SupabasePostRepository()) {
        self.repository = repository
    }

    var canSubmit: Bool {
        selectedImage != nil && selectedKnotType != nil && !isSubmitting
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
        guard let image = selectedImage,
              let knotType = selectedKnotType else { return }

        // 画像を1080px以下にリサイズしてからJPEG化
        let resized = ImageResizer.resize(image, maxDimension: 1080)
        guard let imageData = resized.jpegData(compressionQuality: 0.8) else { return }

        isSubmitting = true
        errorMessage = nil

        Task {
            do {
                try await repository.createPost(
                    imageData: imageData,
                    caption: caption,
                    knotTypeSlug: knotType.rawValue
                )
                showSuccessAlert = true
                resetForm()
            } catch {
                errorMessage = "\(String(localized: "error_post_failed")): \(error.localizedDescription)"
            }
            isSubmitting = false
        }
    }

    private func resetForm() {
        selectedItem = nil
        selectedImage = nil
        caption = ""
        selectedKnotType = nil
    }
}
