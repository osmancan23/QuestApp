//
//  LoginView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject var router: Router
    @ObservedObject var authManager: AuthManager
    @State private var showAlert: Bool = false
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        _viewModel = StateObject(wrappedValue: LoginViewModel(authManager: authManager))
    }
    
    var body: some View {
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
            
            loginButton
            
            registerLink
        }
        .padding(.horizontal, 30)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.isLoggedIn) { newValue in
            if newValue {
                authManager.isLoggedIn = true
                router.navigateToRoot()
            }
        }
        .alert("Hata", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var loginButton: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    viewModel.login()
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
        }
    }
    
    private var registerLink: some View {
        Text("Don't have an account?")
            .font(.subheadline)
            .foregroundColor(.gray)
            .onTapGesture {
                router.navigate(to: .register)
            }
    }
}

#Preview {
    LoginView(authManager: AuthManager())
        .environmentObject(Router())
}


