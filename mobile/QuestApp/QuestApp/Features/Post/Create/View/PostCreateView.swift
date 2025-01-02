import SwiftUI

struct PostCreateView: View {
    @StateObject private var viewModel = PostCreateViewModel()
    @Binding var isPresented: Bool
    let onPost: (String, String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Yeni Gönderi")) {
                    TextField("Başlık", text: $viewModel.title)
                    TextEditor(text: $viewModel.content)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Gönderi Oluştur")
            .navigationBarItems(
                leading: Button("İptal") {
                    isPresented = false
                },
                trailing: Button("Paylaş") {
                    viewModel.sharePost { success in
                        if success {
                            isPresented = false
                        }
                    }
                }
                .disabled(viewModel.title.isEmpty || viewModel.content.isEmpty)
            )
            .alert("Hata", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("Tamam", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
} 
