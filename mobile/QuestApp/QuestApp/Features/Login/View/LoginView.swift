struct LoginView: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    @EnvironmentObject var router: Router
    @ObservedObject var authManager: AuthManager
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                Image("login")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 200)
                    .clipShape(.buttonBorder)
                
                Text("Log In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                TextField("Username", text: $loginViewModel.username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $loginViewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                if loginViewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: {
                        loginViewModel.login()
                    }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
                
                Text("Don't have an account?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        router.navigate(to: .register)
                    }
            }
            .padding(.horizontal, 30)
            .navigationDestination(for: Router.Destination.self) { destination in
                NavigationViewBuilder(destination: destination, authManager: authManager)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: loginViewModel.isLoggedIn) { newValue in
            if newValue {
                authManager.isLoggedIn = true
                router.navigateToRoot()
            }
        }
        .onChange(of: loginViewModel.errorMessage) { newValue in
            showAlert = newValue != nil
        }
        .alert("Hata", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) {
                loginViewModel.errorMessage = nil
            }
        } message: {
            Text(loginViewModel.errorMessage ?? "")
        }
    }
} 