//
//  CategoryCellView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-15.
//

import SwiftUI

struct CategoryCellView: View {

    var title = "Aliens"
    var imageName = Constants.randomImage
    var font = Font.title2
    var cornerRadius: CGFloat = 16

    var body: some View {
        ZStack {
            ImageLoaderView(urlString: imageName)
                .aspectRatio(1, contentMode: .fit)
                .overlay(alignment: .bottomLeading, content: {
                    Text(title)
                        .font(font)
                        .fontWeight(.semibold)
                        .padding(16)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .addingGradientBackgroundForText()
                })
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

#Preview {
    VStack {
        CategoryCellView()
            .frame(width: 150)
        CategoryCellView()
            .frame(width: 300)
    }
}
