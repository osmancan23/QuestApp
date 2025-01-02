import SwiftUI

struct ProfileView: View {
    @ObservedObject var authManager: AuthManager
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            // Profil resmi
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .padding(.top, 32)
            
            // Kullanıcı adı
            Text("@\(authManager.currentUsername)")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 16)
            
            // İstatistikler
            HStack(spacing: 40) {
                VStack {
                    Text("Posts")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("0")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                VStack {
                    Text("Followers")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("0")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                VStack {
                    Text("Following")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("0")
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
            
            Spacer()
        }
        .navigationTitle("Profil")
    }
} 
