import SwiftUI

/// 投稿/ユーザーの通報シート
struct ReportSheet: View {
    let targetType: TargetType
    @Environment(\.dismiss) private var dismiss
    @State private var selectedReason: ReportReason?
    @State private var isSubmitting = false
    @State private var showSuccess = false

    enum TargetType {
        case post(UUID)
        case user(UUID)
    }

    private let repository: ReportRepository = SupabaseReportRepository()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.darkBackground.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text(String(localized: "report_select_reason"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppTheme.spacing)

                    ForEach(ReportReason.allCases) { reason in
                        Button {
                            selectedReason = reason
                        } label: {
                            HStack {
                                Text(reason.displayName)
                                    .foregroundColor(.white)
                                Spacer()
                                if selectedReason == reason {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.rescueOrange)
                                }
                            }
                            .padding(.horizontal, AppTheme.spacing)
                            .padding(.vertical, 12)
                            .background(
                                selectedReason == reason
                                    ? Color.cardBackground
                                    : Color.clear
                            )
                            .cornerRadius(AppTheme.cornerRadius)
                        }
                    }

                    Spacer()

                    Button {
                        Task { await submitReport() }
                    } label: {
                        Group {
                            if isSubmitting {
                                ProgressView().tint(.white)
                            } else {
                                Text(String(localized: "report_submit"))
                                    .fontWeight(.bold)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            selectedReason != nil
                                ? Color.red
                                : Color.subtleGray.opacity(0.3)
                        )
                        .cornerRadius(AppTheme.cornerRadius)
                    }
                    .disabled(selectedReason == nil || isSubmitting)
                    .padding(.horizontal, AppTheme.spacing)
                    .padding(.bottom, AppTheme.spacing)
                }
                .padding(.top, AppTheme.spacing)
            }
            .navigationTitle(String(localized: "report_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(String(localized: "common_cancel")) { dismiss() }
                        .foregroundColor(.rescueOrange)
                }
            }
            .alert(String(localized: "report_success_title"), isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text(String(localized: "report_success_message"))
            }
        }
    }

    private func submitReport() async {
        guard let reason = selectedReason else { return }
        isSubmitting = true
        do {
            switch targetType {
            case .post(let id):
                try await repository.reportPost(postId: id, reason: reason)
            case .user(let id):
                try await repository.reportUser(userId: id, reason: reason)
            }
            showSuccess = true
            Haptics.success()
        } catch {
            print("[ReportSheet] submit failed: \(error)")
        }
        isSubmitting = false
    }
}
