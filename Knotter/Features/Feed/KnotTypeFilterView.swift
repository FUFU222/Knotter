import SwiftUI

/// 横スクロールのチップ形式で結び目タイプをフィルタするビュー
struct KnotTypeFilterView: View {
    let knotTypes: [KnotType]
    @Binding var selectedKnotType: KnotType?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.smallSpacing) {
                // 「すべて」チップ
                chipButton(label: "すべて", isSelected: selectedKnotType == nil) {
                    selectedKnotType = nil
                }

                // 各KnotTypeチップ
                ForEach(knotTypes) { knotType in
                    chipButton(label: knotType.displayName, isSelected: selectedKnotType == knotType) {
                        selectedKnotType = knotType
                    }
                }
            }
            .padding(.horizontal, AppTheme.spacing)
            .padding(.vertical, AppTheme.smallSpacing)
        }
    }

    @ViewBuilder
    private func chipButton(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .subtleGray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.rescueOrange : Color.cardBackground)
                .cornerRadius(AppTheme.cornerRadius)
        }
    }
}
