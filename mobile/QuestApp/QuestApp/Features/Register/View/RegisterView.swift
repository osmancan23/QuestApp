import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var router: Router
    @ObservedObject var authManager: AuthManager
    
    var body: some View {
        VStack {
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350, height: 200)
                .clipShape(.buttonBorder)
            
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            TextField("Username", text: $viewModel.username)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    viewModel.register()
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            
            Text("Already have an account?")
                .font(.subheadline)
                .foregroundColor(.gray)
                .onTapGesture {
                    router.navigate(to: .login)
                }
            
        }
        .padding(.horizontal, 30)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.isRegistered) { newValue in
            if newValue {
                authManager.isLoggedIn = true
                router.navigateToRoot()
            }
        }
        .alert("Hata", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("Tamam", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
} 
