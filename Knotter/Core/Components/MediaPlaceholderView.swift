import SwiftUI

struct MediaPlaceholderView: View {
    let assetName: String
    let mediaType: MediaType

    var body: some View {
        ZStack {
            Color.darkBackground

            if mediaType == .video, assetName.hasPrefix("http"), let url = URL(string: assetName) {
                VideoPlayerView(url: url)
            } else if assetName.hasPrefix("http") {
                AsyncImage(url: URL(string: assetName)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholderView
                    case .empty:
                        ProgressView()
                            .tint(.rescueOrange)
                    @unknown default:
                        placeholderView
                    }
                }
            } else if let uiImage = UIImage(named: assetName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholderView
            }
        }
    }

    private var placeholderView: some View {
        VStack(spacing: AppTheme.smallSpacing) {
            Image(systemName: mediaType == .video ? "video.fill" : "photo.fill")
                .font(.system(size: 48))
                .foregroundColor(.subtleGray)
            Text(mediaType == .video ? String(localized: "media_video") : String(localized: "media_photo"))
                .font(.caption)
                .foregroundColor(.subtleGray)
        }
    }
}
