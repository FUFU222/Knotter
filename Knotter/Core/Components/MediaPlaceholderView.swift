import SwiftUI

struct MediaPlaceholderView: View {
    let assetName: String
    let mediaType: MediaType

    var body: some View {
        ZStack {
            Color.darkBackground

            // Attempt to load asset image; fall back to placeholder
            if let uiImage = UIImage(named: assetName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                VStack(spacing: AppTheme.smallSpacing) {
                    Image(systemName: mediaType == .video ? "video.fill" : "photo.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.subtleGray)
                    Text(mediaType == .video ? "動画" : "写真")
                        .font(.caption)
                        .foregroundColor(.subtleGray)
                }
            }
        }
    }
}
