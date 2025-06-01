//
//  CorePermissionCard.swift
//  flutter_permission_kit
//
//  Created by MaoJiu on 2025/5/28.
//

import SwiftUI

@available(iOS 15.0, *)
struct CorePermissionCard: View {
    var icon: String
    
    var title: String
    
    var description: String
    
    var status: AuthorizationStatus
    
    var onTap: () -> Void
    
    var buttonText: String {
        switch status {
        case .notDetermined:
            return "Allow"
        case .limited:
            return "Limited"
        case .granted:
            return "Allowed"
        case .denied:
            return "Denied"
        }
    }
    
    var buttonForegroundStyle: Color {
        switch status {
        case .granted, .denied, .limited:
                .gray
        case .notDetermined:
                .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline.bold())
                
                Text(description)
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                onTap()
            } label: {
                Text(buttonText)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .foregroundStyle(buttonForegroundStyle)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 30,
                            style: .continuous
                        )
                        .fill(
                            Color(
                                UIColor.secondarySystemBackground
                            )
                        )
                    )
            }
        }
    }
}
