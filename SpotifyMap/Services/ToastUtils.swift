//
//  ToastUtils.swift
//  SpotifyMap
//
//  Created by Leevi on 20.4.2022.
//

import Foundation
import SwiftUI

func createTopToast(toastText: String) -> some View {
    GeometryReader { geometry in
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Rectangle()
                    .fill(Color(hex:0x1ED760))
                    .frame(maxWidth: 4, maxHeight: 50, alignment: .leading)
                VStack(alignment: .leading) {
                    Text(toastText)
                        .lineLimit(5)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
                }
                Spacer()
            }
            .frame(width: geometry.size.width - 40, height: 70)
            .background(Color(hex: 0x221c48))
            .cornerRadius(15)
            .padding(.top, 50)
            .padding(.leading, 20)
        }
    }
}

