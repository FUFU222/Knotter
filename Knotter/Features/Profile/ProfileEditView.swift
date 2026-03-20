import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.darkBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: AppTheme.spacing) {
                        // Avatar picker
                        PhotosPicker(
                            selection: $viewModel.avatarItem,
                            matching: .images
                        ) {
                            ZStack {
                                if let avatarImage = viewModel.avatarImage {
                                    Image(uiImage: avatarImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 96, height: 96)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.cardBackground)
                                        .frame(width: 96, height: 96)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(.subtleGray)
                                        )
                                }

                                Circle()
                                    .fill(.black.opacity(0.4))
                                    .frame(width: 96, height: 96)

                                Image(systemName: "camera.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                        }
                        .onChange(of: viewModel.avatarItem) { _ in
                            Task { await viewModel.loadAvatarImage() }
                        }
                        .padding(.top, 8)

                        // Username
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ユーザー名")
                                .font(.caption)
                                .foregroundColor(.subtleGray)
                            TextField("@username", text: $viewModel.editingUsername)
                                .padding(14)
                                .background(Color.cardBackground)
                                .cornerRadius(AppTheme.cornerRadius)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }

                        // Display name
                        VStack(alignment: .leading, spacing: 4) {
                            Text("表示名")
                                .font(.caption)
                                .foregroundColor(.subtleGray)
                            TextField("表示名（任意）", text: $viewModel.editingDisplayName)
                                .padding(14)
                                .background(Color.cardBackground)
                                .cornerRadius(AppTheme.cornerRadius)
                                .foregroundColor(.white)
                        }

                        // Bio
                        VStack(alignment: .leading, spacing: 4) {
                            Text("自己紹介")
                                .font(.caption)
                                .foregroundColor(.subtleGray)
                            TextField("自己紹介（任意）", text: $viewModel.editingBio, axis: .vertical)
                                .lineLimit(3...5)
                                .padding(14)
                                .background(Color.cardBackground)
                                .cornerRadius(AppTheme.cornerRadius)
                                .foregroundColor(.white)
                                .onChange(of: viewModel.editingBio) { _ in
                                    viewModel.enforceMaxBio()
                                }
                            Text("\(viewModel.editingBio.count)/\(ProfileViewModel.maxBioLength)")
                                .font(.caption2)
                                .foregroundColor(.subtleGray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                        // Error
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.rescueOrange)
                        }

                        // Save button
                        Button {
                            Task { await viewModel.saveProfile() }
                        } label: {
                            Group {
                                if viewModel.isSaving {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("保存")
                                        .fontWeight(.bold)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.rescueOrange)
                            .cornerRadius(AppTheme.cornerRadius)
                        }
                        .disabled(viewModel.isSaving)
                    }
                    .padding(AppTheme.spacing)
                }
            }
            .navigationTitle("プロフィール編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        viewModel.cancelEditing()
                        dismiss()
                    }
                    .foregroundColor(.subtleGray)
                }
            }
        }
    }
}
