struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibility(identifier: "usernameField")
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibility(identifier: "passwordTextField")
            
            if !viewModel.emailValidationMessage.isEmpty {
                Text(viewModel.emailValidationMessage)
                    .foregroundColor(.red)
                    .accessibility(identifier: "emailValidationText")
            }
            
            if !viewModel.passwordValidationMessage.isEmpty {
                Text(viewModel.passwordValidationMessage)
                    .foregroundColor(.red)
                    .accessibility(identifier: "passwordValidationText")
            }
            
            Button("Login") {
                viewModel.login()
            }
            .accessibility(identifier: "loginButton")
        }
        .padding()
        .accessibility(identifier: "loginView")
        .alert("Hata", isPresented: $viewModel.showError) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .accessibility(identifier: "errorAlert")
    }
} 