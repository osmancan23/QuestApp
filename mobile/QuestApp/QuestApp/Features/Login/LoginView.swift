//
//  LoginView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import SwiftUI
struct LoginView: View {
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) { // NavigationStack ile çevreleme
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

                TextField("Username", text: .constant(""))
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 20)

                SecureField("Password", text: .constant(""))
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 20)



                Button(action: {
                    router.navigateAndReplace(to: .feed)

                }, label: {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })


                    .padding(.bottom, 20)


                Text("Don't have an account?")
                    .font(.subheadline)
                    .foregroundColor(.gray).onTapGesture {
                    router.navigate(to: .register)

                }


            } .padding(.horizontal, 30)

                .navigationDestination(for: Router.Destination.self) { destination in // NavigationDestination doğru yerde
                NavigationViewBuilder(destination: destination)
            }
        }
    }
}


#Preview {
    LoginView().environmentObject(Router())
}



