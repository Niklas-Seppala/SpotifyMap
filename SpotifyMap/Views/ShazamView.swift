//
//  ShazamView.swift
//  SpotifyMap
//
//  Created by iosdev on 27.4.2022.
//

import SwiftUI

struct ShazamView: View {
    @StateObject private var viewModel = ShazamViewModel()
    
    var body: some View {
                VStack(alignment: .center) {
                    Text(viewModel.shazamMedia.title ?? "Unknown")
                    Text(viewModel.shazamMedia.artistName ?? "Unknown")
                }.padding()
                Button(action: { viewModel.startOrEndListening()}) {
                    Text(viewModel.isRecording ? "Listening..." : "Shazam")
                        .frame(width: 300)
                }
        }
}

    

struct ShazamView_Previews: PreviewProvider {
    static var previews: some View {
        ShazamView()
    }
}
