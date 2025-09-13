//
//  View+Extensions.swift
//  TogetherList
//

import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    func primaryButton() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pink)
            .cornerRadius(12)
    }
    
    func secondaryButton() -> some View {
        self
            .font(.headline)
            .foregroundColor(.pink)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pink.opacity(0.1))
            .cornerRadius(12)
    }
}