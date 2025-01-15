//
//  CustomListCellView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-15.
//

import SwiftUI

struct CustomListCellView: View {

    var imageName: String?
    var title: String?
    var subtitle: String?

    var body: some View {
        HStack(spacing: 8) {
            Group {
                if let imageName {
                    ImageLoaderView(urlString: imageName)

                } else {
                    Rectangle()
                        .fill(.accent.opacity(0.3))
                        .frame(height: 60)

                }
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.headline)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .padding(.vertical, 4)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        VStack {
            CustomListCellView(imageName: Constants.randomImage, title: "alpha", subtitle: "subtitle")
            CustomListCellView(imageName: nil, title: "alpha", subtitle: "subtitle")
            CustomListCellView()
        }
    }
}
