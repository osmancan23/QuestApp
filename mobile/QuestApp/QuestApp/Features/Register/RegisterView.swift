//
//  RegisterView.swift
//  QuestApp
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var router: Router

    var body: some View {

        VStack(content: {

            Image("login").resizable().aspectRatio(contentMode: .fill).frame(width: 350, height: 200).clipShape(.buttonBorder)
            Text("Sign Up").font(.largeTitle).fontWeight(.bold).padding(.bottom, 20)
            TextField("Username", text: .constant("")).padding().background(Color(.secondarySystemBackground)).cornerRadius(10).padding(.bottom, 20)
            SecureField("Password", text: .constant("")).padding().background(Color(.secondarySystemBackground)).cornerRadius(10).padding(.bottom, 20)
            Button(action: { }, label: {
                    Text("Sign Up").font(.headline).foregroundColor(.white).padding().frame(maxWidth: .infinity).background(Color.blue).cornerRadius(10)
                }).padding(.bottom, 20)

                Text("Already have an account?").font(.subheadline).foregroundColor(.gray)
                    .font(.subheadline)
                    .foregroundColor(.gray).onTapGesture {
                        router.navigateBack()
                    }
            
        }).padding(.horizontal, 30).navigationBarBackButtonHidden()

    }
}

#Preview {
    RegisterView().environmentObject(Router())
}
