//
//  SharedStyles.swift
//  Trivia
//
//  Created by ahmed.elakpawy on 31.10.24.
//

import SwiftUI

struct TriviaTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.white)
            .tint(.white)
            .accentColor(.white)
    }
}
