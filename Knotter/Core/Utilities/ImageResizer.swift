import UIKit

enum ImageResizer {
    /// 最大辺を指定サイズに縮小（アスペクト比維持）
    /// 元画像が既に小さい場合はそのまま返す
    static func resize(_ image: UIImage, maxDimension: CGFloat = 1080) -> UIImage {
        let size = image.size
        guard max(size.width, size.height) > maxDimension else { return image }

        let ratio: CGFloat
        if size.width > size.height {
            ratio = maxDimension / size.width
        } else {
            ratio = maxDimension / size.height
        }

        let newSize = CGSize(
            width: (size.width * ratio).rounded(),
            height: (size.height * ratio).rounded()
        )

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
