//
//  ChatRowCellView.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-15.
//

import SwiftUI

struct ChatRowCellView: View {

    var imageName: String?
    var headline: String?
    var subheadline: String?
    var hasNewChat: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Group {
                if let imageName {
                    ImageLoaderView(urlString: imageName)
                } else {
                    Rectangle()
                        .fill(.secondary.opacity(0.5))
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                if let headline {
                    Text(headline)
                        .font(.headline)
                }
                if let subheadline {
                    Text(subheadline)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if hasNewChat {
                Text("NEW")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 6)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        List {
            Group {
                ChatRowCellView(imageName: Constants.randomImage, headline: "Alpha", subheadline: "this is the last message in the chat.", hasNewChat: true)
                ChatRowCellView(imageName: Constants.randomImage, headline: "Chat", subheadline: "this is the last message in the chat.", hasNewChat: false)
                ChatRowCellView(imageName: nil, headline: "Alpha", subheadline: "this is the last message in the chat.", hasNewChat: true)
            }
            .removeListRowFormatting()
        }
    }
}
