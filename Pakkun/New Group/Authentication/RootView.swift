//
//  RootView.swift
//  Pakkun
//
//  Created by New Student on 1/22/25.
//

import SwiftUI

//struct RootView: View {
//    
//    @State private var showSignInView: Bool = false
//    
//    var body: some View {
//        ZStack {
//            NavigationStack {
//                SettingView(showSignInView: $showSignInView)
//                
//            }
//        }
//        .onAppear {
//            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
//            self.showSignInView = authUser == nil // if authUser == nil ? true : false  is true, it will return true, if it's false it will retruen false. The terngy operter is optional we dont need it. 
//        }
//        .fullScreenCover(isPresented: $showSignInView) {
//            NavigationStack {
//                AuthenticationView(showSignInView: $showSignInView)
//        }
//        }
//        
//    }
//}
//
//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
