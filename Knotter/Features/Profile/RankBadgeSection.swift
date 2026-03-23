import SwiftUI

/// プロフィールに表示するランク＆バッジセクション
struct RankBadgeSection: View {
    @ObservedObject var viewModel: RankBadgeViewModel
    @State private var showAllBadges = false

    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Rank & Streak Row
            HStack(spacing: 16) {
                // Rank display
                HStack(spacing: 8) {
                    Image(systemName: viewModel.rank.iconName)
                        .font(.title3)
                        .foregroundColor(viewModel.rank.color)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.rank.displayName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        // Progress bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.white.opacity(0.15))
                                    .frame(height: 6)

                                RoundedRectangle(cornerRadius: 3)
                                    .fill(
                                        LinearGradient(
                                            colors: [viewModel.rank.color, viewModel.rank.color.opacity(0.6)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geo.size.width * viewModel.rankProgress, height: 6)
                            }
                        }
                        .frame(height: 6)
                    }
                }
                .frame(maxWidth: .infinity)

                // Streak display
                if let stats = viewModel.userStats, stats.currentStreak > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.title3)
                            .foregroundColor(.rescueOrange)

                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(stats.currentStreak)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(String(localized: "profile_streak_days"))
                                .font(.caption2)
                                .foregroundColor(.subtleGray)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.rescueOrange.opacity(0.15))
                    .cornerRadius(10)
                }
            }

            // MARK: - Badge Collection
            if !viewModel.allBadges.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(String(localized: "profile_badges"))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Spacer()

                        Button {
                            showAllBadges = true
                        } label: {
                            Text(String(localized: "badge_see_all"))
                                .font(.caption)
                                .foregroundColor(.rescueOrange)
                        }
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.allBadges) { badge in
                                BadgeIcon(
                                    badge: badge,
                                    isEarned: viewModel.isEarned(badge)
                                )
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .sheet(isPresented: $showAllBadges) {
            BadgeCollectionView(viewModel: viewModel)
        }
    }
}

// MARK: - Badge Icon

struct BadgeIcon: View {
    let badge: BadgeDefinition
    let isEarned: Bool

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(isEarned ? badge.badgeCategory.accentColor.opacity(0.2) : Color.white.opacity(0.05))
                    .frame(width: 48, height: 48)

                Image(systemName: badge.iconName)
                    .font(.title3)
                    .foregroundColor(isEarned ? badge.badgeCategory.accentColor : .gray.opacity(0.4))
            }

            Text(badge.localizedName)
                .font(.system(size: 9))
                .foregroundColor(isEarned ? .white : .gray.opacity(0.5))
                .lineLimit(1)
                .frame(width: 56)
        }
        .opacity(isEarned ? 1.0 : 0.5)
    }
}

// MARK: - Badge Category Color

extension BadgeCategory {
    var accentColor: Color {
        switch self {
        case .knot: return .rescueOrange
        case .streak: return .red
        case .milestone: return .yellow
        case .social: return .cyan
        }
    }
}
