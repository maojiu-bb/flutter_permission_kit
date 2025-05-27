//
//  CorePermissionView.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/26.
//

import SwiftUI


@available(iOS 15.0, *)
struct CorePermissionView<Content: View>: View {
    let displayTitle: String
    let displayHeaderDescription: String
    let displayBottomDescription: String
    let content: () -> Content
    
    init(
        displayTitle: String,
        displayHeaderDescription: String,
        displayBottomDescription: String,
        content: @escaping () -> Content
    ) {
        self.displayTitle = displayTitle
        self.displayHeaderDescription = displayHeaderDescription
        self.displayBottomDescription = displayBottomDescription
        self.content = content
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(displayTitle)
                .font(.title.bold())
                .foregroundStyle(.primary)
                .padding(.bottom)
            
            Text(displayHeaderDescription)
                .font(.callout)
                .foregroundStyle(.secondary)
            
            VStack {
                content()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .fill(.background)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.vertical)
            
            Text(displayBottomDescription)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding(30)
        .background(
            RoundedRectangle(
                cornerRadius: 30,
                style: .continuous
            )
            .fill(Color(.secondarySystemBackground))
        )
        .padding()
    }
}
