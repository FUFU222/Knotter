import Foundation

enum MockPosts {
    static let samples: [Post] = [
        Post(
            id: UUID(),
            username: "@rescue_knot",
            mediaType: .image,
            mediaAssetName: "knot_bowline",
            caption: "現場で一番信頼できる結び。もやい結びは命を預ける基本中の基本。",
            knotType: .bowline,
            likeCount: 128,
            isLiked: false
        ),
        Post(
            id: UUID(),
            username: "@outdoor_master",
            mediaType: .video,
            mediaAssetName: "knot_clove",
            caption: "テント設営に最適！巻き結びのコツを解説します。",
            knotType: .cloveHitch,
            likeCount: 85,
            isLiked: true
        ),
        Post(
            id: UUID(),
            username: "@fire_brigade_07",
            mediaType: .image,
            mediaAssetName: "knot_figure8",
            caption: "エイトノットは登山でもレスキューでも必須。確実に覚えよう。",
            knotType: .figureEight,
            likeCount: 256,
            isLiked: false
        ),
        Post(
            id: UUID(),
            username: "@rope_tech",
            mediaType: .video,
            mediaAssetName: "knot_slip",
            caption: "引き解け結びの素早い解除テクニック。緊急時に差がつく。",
            knotType: .slipKnot,
            likeCount: 64,
            isLiked: false
        ),
        Post(
            id: UUID(),
            username: "@mountain_rescue",
            mediaType: .image,
            mediaAssetName: "knot_twohalf",
            caption: "ふた結びで支点構築。シンプルだけど確実な固定方法。",
            knotType: .twoHalfHitches,
            likeCount: 42,
            isLiked: true
        ),
    ]
}
