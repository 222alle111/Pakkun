//
//  ContentView.swift
//  Pakkun
//
//  Created by New Student on 1/21/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewMoodel: AuthViewModel
    
    var body: some View {
       Group {
            if viewMoodel.userSession != nil {
                UserProfileView()
            } else {
                HomePageView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
