import SwiftUI
import PhotosUI

struct UploadView: View {
    @StateObject private var viewModel = UploadViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.spacing) {
                    // Media picker
                    PhotosPicker(
                        selection: $viewModel.selectedItem,
                        matching: .any(of: [.images, .videos])
                    ) {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 260)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(AppTheme.cornerRadius)
                        } else {
                            VStack(spacing: AppTheme.smallSpacing) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.rescueOrange)
                                Text(String(localized: "upload_select_media"))
                                    .font(.subheadline)
                                    .foregroundColor(.subtleGray)
                            }
                            .frame(height: 260)
                            .frame(maxWidth: .infinity)
                            .background(Color.cardBackground)
                            .cornerRadius(AppTheme.cornerRadius)
                        }
                    }
                    .onChange(of: viewModel.selectedItem) { _ in
                        Task { await viewModel.loadImage() }
                    }

                    // Caption
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "upload_caption"))
                            .font(.caption)
                            .foregroundColor(.subtleGray)
                        TextField(String(localized: "upload_caption_hint"), text: $viewModel.caption, axis: .vertical)
                            .lineLimit(3...5)
                            .padding(12)
                            .background(Color.cardBackground)
                            .cornerRadius(AppTheme.cornerRadius)
                            .foregroundColor(.white)
                            .onChange(of: viewModel.caption) { _ in
                                viewModel.enforceMaxCaption()
                            }
                        Text("\(viewModel.caption.count)/\(UploadViewModel.maxCaptionLength)")
                            .font(.caption2)
                            .foregroundColor(.subtleGray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    // Knot type picker
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "upload_knot_type"))
                            .font(.caption)
                            .foregroundColor(.subtleGray)
                        Picker(String(localized: "upload_knot_type_picker"), selection: $viewModel.selectedKnotType) {
                            Text(String(localized: "upload_knot_type_placeholder")).tag(KnotType?.none)
                            ForEach(KnotType.allCases) { knot in
                                Text(knot.displayName).tag(KnotType?.some(knot))
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.cardBackground)
                        .cornerRadius(AppTheme.cornerRadius)
                        .tint(.rescueOrange)
                    }

                    // Submit button
                    Button(action: { viewModel.submit() }) {
                        Text(String(localized: "upload_submit"))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(viewModel.canSubmit ? Color.rescueOrange : Color.subtleGray.opacity(0.3))
                            .cornerRadius(AppTheme.cornerRadius)
                    }
                    .disabled(!viewModel.canSubmit)
                }
                .padding(AppTheme.spacing)
            }
            .background(Color.darkBackground)
            .navigationTitle(String(localized: "upload_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .alert(String(localized: "upload_success_title"), isPresented: $viewModel.showSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(String(localized: "upload_success_message"))
            }
            .alert(String(localized: "upload_error_title"), isPresented: .init(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
