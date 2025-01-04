import SwiftUI

struct ProfileView: View {
    @ObservedObject var authManager: AuthManager
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                // Profil resmi
                Image("login")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding(.top, 32)
                
                // Kullanıcı adı
                Text("@\(user.name)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 16)
                
                // İstatistikler
                HStack(spacing: 40) {
                    VStack {
                        Text("Gönderiler")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(viewModel.postCount)")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    VStack {
                        Text("Beğeniler")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(viewModel.likeCount)")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.top, 24)
                
                // Çıkış yap butonu
                Button(action: {
                    authManager.logout()
                    router.navigate(to: .login)
                }) {
                    Text("Çıkış Yap")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.top, 32)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .navigationTitle("Profil")
        .onAppear {
            viewModel.fetchUserData()
        }
    }
} 
