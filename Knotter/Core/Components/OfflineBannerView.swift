import SwiftUI

/// ネットワーク未接続時に画面上部に表示するバナー
struct OfflineBannerView: View {
    @ObservedObject private var monitor = NetworkMonitor.shared

    var body: some View {
        if !monitor.isConnected {
            HStack(spacing: 8) {
                Image(systemName: "wifi.slash")
                    .font(.caption)
                Text(String(localized: "error_network"))
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.red.opacity(0.85))
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}
