//
//  ToastUtils.swift
//  SpotifyMap
//
//  Created by Leevi on 20.4.2022.
//

import Foundation
import SwiftUI

enum ToastStatus: UInt {
    case Error = 0xf06156
    case Success = 0x1ED760
    
    var color: Color {
        Color(hex: rawValue)
    }
}

func createTopToast(toastText: String, status: ToastStatus) -> some View {
    GeometryReader { geometry in
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Rectangle()
                    .fill(status.color)
                    .frame(maxWidth: 12, maxHeight: geometry.size.height)
                VStack(alignment: .center) {
                    Text(toastText)
                        .lineLimit(5)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.leading)
                    
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

