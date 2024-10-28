//
//  CategoryCard.swift
//  Trivia
//
//  Created by ahmed.elakpawy on 30.10.24.
//

import SwiftUI

struct CategoryCard: View {
    let category: QuizCategory
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: category.icon)
                .font(.system(size: 30))
            
            Text(category.rawValue)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(category.description)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(height: 180)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "2E1C4A").opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(category.color,
                        lineWidth: isSelected ? 2 : 0)
        )
        .foregroundColor(isSelected ? category.color : .white)
    }
}

// Preview provider for testing
struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCard(
            category: .general,
            isSelected: true
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.black)
    }
}
