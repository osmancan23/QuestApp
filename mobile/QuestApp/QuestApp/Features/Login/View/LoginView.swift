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

            Group {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
                .id("usernameField")
                .accessibility(identifier: "usernameField")

            Group {
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
                .id("passwordField")
                .accessibility(identifier: "passwordField")

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
            .alert("Hata", isPresented: $viewModel.isError) {
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
                    .id("loginButton")
                    .accessibility(identifier: "loginButton")
                    .padding(.bottom, 20)
            }
        }
    }

    private var registerLink: some View {
        Text("Don't have an account?")
            .font(.subheadline)
            .foregroundColor(.gray)
            .id("registerLink")
            .accessibility(identifier: "registerLink")
            .onTapGesture {
            router.navigate(to: .register)
        }
    }
}

#Preview {
    LoginView(authManager: AuthManager())
        .environmentObject(Router())
}


