import SwiftUI

/// 全バッジを一覧表示するビュー
struct BadgeCollectionView: View {
    @ObservedObject var viewModel: RankBadgeViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Summary
                    HStack(spacing: 20) {
                        statItem(
                            value: "\(viewModel.earnedBadges.count)",
                            label: String(localized: "badge_earned_count")
                        )
                        statItem(
                            value: "\(viewModel.allBadges.count)",
                            label: String(localized: "badge_total_count")
                        )
                    }
                    .padding(.top, 8)

                    // Badge grid by category
                    ForEach(BadgeCategory.allCases, id: \.self) { category in
                        let badges = viewModel.badgesByCategory(category)
                        if !badges.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(category.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)

                                LazyVGrid(
                                    columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ],
                                    spacing: 16
                                ) {
                                    ForEach(badges) { badge in
                                        BadgeDetailItem(
                                            badge: badge,
                                            isEarned: viewModel.isEarned(badge)
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.darkBackground)
            .navigationTitle(String(localized: "badge_collection_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(String(localized: "common_close")) { dismiss() }
                        .foregroundColor(.rescueOrange)
                }
            }
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.rescueOrange)
            Text(label)
                .font(.caption)
                .foregroundColor(.subtleGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

// MARK: - Badge Detail Item

struct BadgeDetailItem: View {
    let badge: BadgeDefinition
    let isEarned: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(isEarned ? badge.badgeCategory.accentColor.opacity(0.2) : Color.white.opacity(0.05))
                    .frame(width: 56, height: 56)

                Image(systemName: badge.iconName)
                    .font(.title2)
                    .foregroundColor(isEarned ? badge.badgeCategory.accentColor : .gray.opacity(0.3))

                if !isEarned {
                    Image(systemName: "lock.fill")
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.5))
                        .offset(x: 18, y: 18)
                }
            }

            Text(badge.localizedName)
                .font(.system(size: 10))
                .foregroundColor(isEarned ? .white : .gray.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            if let desc = badge.localizedDescription {
                Text(desc)
                    .font(.system(size: 8))
                    .foregroundColor(.subtleGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .opacity(isEarned ? 1.0 : 0.6)
    }
}
