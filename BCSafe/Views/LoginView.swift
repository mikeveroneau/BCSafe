//
//  LoginView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var loginVM: LoginViewModel

    @State private var presentSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Image("logoNoBG")
                .resizable()
                .scaledToFit()
                .padding()
            
            Text("Keeping Our Community Safer")
                .multilineTextAlignment(.center)
                .font(.custom("Avenir", size: 40))
                .foregroundColor(Color("BCGold"))
                .bold()
                .italic()
                .padding(.top, 50)
            
            Spacer()
            
            Button {
                Task {
                    presentSheet = await loginVM.signInWithGoogle()
                    if !presentSheet {
                        showingAlert = true
                        alertMessage = "Couldn't sign in! Are you sure that you are using a valid Boston College email?"
                    }
                }
            } label: {
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 37, height: 37)
                        
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    
                    Text("Login With School Email")
                        .foregroundColor(Color("BCMaroon"))
                        .font(.system(size: 20))
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("BCGold"))
            
            Spacer()
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                //if user is already logged in before
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            HomeBarView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}
