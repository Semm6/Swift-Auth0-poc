# Swift-Auth0-poc

This app is an poc to make a login using Auth0. If you want to try it yourself here is a small tutorial on how to do it.

## 1. Configure Auth0

Get your application keys. You can get these keys when creating a new application on Auth0.com. With this link below you can login and go to applications to create a new one.

- [Auth0](https://auth0.auth0.com/u/login/identifier?state=hKFo2SBYdzFjM3BUQnl6WWtQYXJzaENJZTNtUFFlVEJCc0RRWqFur3VuaXZlcnNhbC1sb2dpbqN0aWTZIGNtbnZjZF83U19BMnRaVVZXa2t6Y3lkMGhPWV83bURmo2NpZNkgekVZZnBvRnpVTUV6aWxoa0hpbGNXb05rckZmSjNoQUk)

## 2. Configure callback URL and logout URL

You can change these URLs in the application settings. The product_bundle_identifier is located in the settings on your application in Xcode.

Product bundle identifier:

> com.company.myapp://company.auth0.com/ios/com.company.myapp/callback

Callback and logout URL:

> {PRODUCT_BUNDLE_IDENTIFIER}://{YOUR_ACCOUNT}.us.auth0.com/ios/{PRODUCT_BUNDLE_IDENTIFIER}/callback

## 3. Start authentication

To be able to use Auth0 we need some dependencies. To get these you can add a package to the Swift Package manager. This is the URL for it:

> https://github.com/auth0/Auth0.swift.git

## 4. Implement Login and logout

Add the code below to the file where you want to present the login page:

```swift
import Auth0
```

Then add the following code to add the login and logout button:

```swift
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
```
