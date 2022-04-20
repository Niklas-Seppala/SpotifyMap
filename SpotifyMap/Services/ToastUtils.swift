//
//  ToastUtils.swift
//  SpotifyMap
//
//  Created by Leevi on 20.4.2022.
//

import Foundation
import SwiftUI

func createTopToast(toastText: String) -> some View {
    VStack(alignment: .leading) {
        //Rectangle().frame(height: 5)
        HStack(alignment: .center) {
            Rectangle()
                .fill(Color(hex:0x1ED760))
                .frame(maxWidth: 20, maxHeight:.infinity, alignment: .leading)
            VStack(alignment: .leading) {
                    Text(toastText)
                        .lineLimit(10)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
            }
            Spacer()
        }
        .frame(height: 125)
        .frame(maxWidth: .infinity)
        .background(Color(hex: 0x221c48))
        .cornerRadius(15)
    }
}

