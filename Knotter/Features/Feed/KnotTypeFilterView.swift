import SwiftUI

/// 横スクロールのチップ形式で結び目タイプをフィルタするビュー
struct KnotTypeFilterView: View {
    let knotTypes: [KnotType]
    @Binding var selectedKnotType: KnotType?
    @Namespace private var chipAnimation

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.smallSpacing) {
                // 「すべて」チップ
                chipButton(
                    id: "all",
                    label: String(localized: "filter_all"),
                    isSelected: selectedKnotType == nil
                ) {
                    withAnimation(AppTheme.springSnappy) {
                        selectedKnotType = nil
                    }
                    Haptics.selection()
                }

                // 各KnotTypeチップ
                ForEach(knotTypes) { knotType in
                    chipButton(
                        id: knotType.rawValue,
                        label: knotType.displayName,
                        isSelected: selectedKnotType == knotType
                    ) {
                        withAnimation(AppTheme.springSnappy) {
                            selectedKnotType = knotType
                        }
                        Haptics.selection()
                    }
                }
            }
            .padding(.horizontal, AppTheme.spacing)
            .padding(.vertical, AppTheme.smallSpacing)
        }
    }

    @ViewBuilder
    private func chipButton(id: String, label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .subtleGray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    if isSelected {
                        Capsule()
                            .fill(LinearGradient.orangeGlow)
                            .matchedGeometryEffect(id: "chipBg", in: chipAnimation)
                    } else {
                        Capsule()
                            .fill(Color.cardBackground)
                    }
                }
        }
    }
}
