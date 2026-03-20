import SwiftUI
import AVKit

/// 動画再生ビュー（AVPlayer使用）
struct VideoPlayerView: View {
    let url: URL
    @State private var player: AVPlayer?
    @State private var isPlaying = false

    var body: some View {
        ZStack {
            Color.darkBackground

            if let player {
                VideoPlayer(player: player)
                    .onDisappear {
                        player.pause()
                    }
            } else {
                ProgressView()
                    .tint(.rescueOrange)
            }

            // Tap to play/pause
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    togglePlayback()
                }

            // Play button overlay when paused
            if !isPlaying {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.white.opacity(0.8))
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            setupPlayer()
        }
    }

    private func setupPlayer() {
        let avPlayer = AVPlayer(url: url)
        avPlayer.isMuted = false
        self.player = avPlayer

        // ループ再生
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: avPlayer.currentItem,
            queue: .main
        ) { _ in
            avPlayer.seek(to: .zero)
            avPlayer.play()
        }

        avPlayer.play()
        isPlaying = true
    }

    private func togglePlayback() {
        guard let player else { return }
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
}
