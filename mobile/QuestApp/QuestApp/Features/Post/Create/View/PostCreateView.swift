import SwiftUI

struct PostCreateView: View {
    @StateObject private var viewModel = PostCreateViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showImagePicker = false
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextEditor(text: $viewModel.content)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text(viewModel.selectedImage == nil ? "Resim Seç" : "Resim Seçildi")
                        }
                    }
                    
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.sharePost()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Paylaş")
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .navigationTitle("Yeni Gönderi")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
            .alert("Hata", isPresented: .init(get: { viewModel.errorMessage != nil },
                                            set: { _ in viewModel.errorMessage = nil })) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .alert("Başarılı", isPresented: .init(get: { viewModel.successMessage != nil },
                                               set: { _ in
                viewModel.successMessage = nil
                dismiss()
            })) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text(viewModel.successMessage ?? "")
            }
        }
    }
}
