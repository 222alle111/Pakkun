//
//  SettingRowView.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
//

import SwiftUI

struct SettingRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: imageName)
                    .imageScale(.small)
                    .font(.title)
                    .foregroundColor(tintColor)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.white)
//                    .shadow(radius: 2)
//            )
        }
    }
}
//struct SettingRowView: View {
//    let imageName: String
//    let title: String
//    let tintColor: Color
//    
//    var body: some View {
//        HStack {
//            Image(systemName: imageName)
//                .imageScale(.small)
//                .font(.title)
//                .foregroundColor(tintColor)
//            
//            Text(title)
//                .font(.subheadline)
//                .foregroundColor(.black)
//        }
//    }
//}


//struct SettingRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingRowView(imageName: "heart", title: "Pet Profile", tintColor: Color(.systemPink))
//    }
//}
