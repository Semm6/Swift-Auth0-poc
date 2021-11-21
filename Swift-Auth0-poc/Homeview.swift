//
//  ContentView.swift
//  Swift-Auth0-poc
//
//  Created by Sem de Wilde on 21/11/2021.
//

import SwiftUI
import AuthenticationServices
import Auth0

struct Homeview: View {
    
    @State private var myToken = ""
    @State private var status = false
    
    var body: some View {
        VStack {
            
            Text("Status: " + (status ? "Logged in" : "Not logged in"))
                .padding()
            
            Button  {
                Auth0
                    .webAuth()
                    .scope("openid profile")
                    .audience("https://dev-nbbojs57.us.auth0.com/userinfo")
                    .start { result in
                        switch result {
                        case .failure(let error):
                            // Handle the error
                            print("Auth- Error: \(error)")
                        case .success(let credentials):
                            // Do something with credentials e.g.: save them.
                            // Auth0 will automatically dismiss the login page
                            print("Auth0 Credentials: \(credentials)")
                            
                            if let token =  credentials.accessToken {
                                myToken = token
                            }
                            status = true
                        }
                }
            } label: {
                Text("Login with Auth0")
                    .padding()
            }
            
            Button {
                Auth0
                    .webAuth()
                    .clearSession(federated: false) { result in
                        if result {
                            // Session cleared
                            print("Logged out")
                        }
                        status = false
                    }
            } label: {
                Text("Logout")
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Homeview()
.previewInterfaceOrientation(.portrait)
    }
}
    
