//
//  ImageLoaderView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-11.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {

    var urlString: String
    var resizingMode = ContentMode.fill

    var body: some View {
        Rectangle()
            .opacity(0.0001)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            }
            .clipped()
    }
}

#Preview {
    ImageLoaderView(urlString: Constants.randomImage)
        .frame(width: 100, height: 200)
}
