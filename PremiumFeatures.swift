import SwiftUI

struct PremiumFeatures {
    let price: Decimal = 4.99
    let features: [PremiumFeature] = [
        PremiumFeature(
            title: "Unlimited Weekly Challenges",
            description: "Access exclusive weekly themed challenges",
            icon: "calendar.badge.clock"
        ),
        PremiumFeature(
            title: "Advanced Game Modes",
            description: "Unlock all time attack options and special modes",
            icon: "gamecontroller.fill"
        ),
        PremiumFeature(
            title: "Custom Challenge Creation",
            description: "Create and share custom challenges with friends",
            icon: "person.2.fill"
        ),
        PremiumFeature(
            title: "Premium Question Sets",
            description: "Access exclusive premium questions and categories",
            icon: "star.fill"
        ),
        PremiumFeature(
            title: "Advanced Statistics",
            description: "Detailed performance analytics and insights",
            icon: "chart.bar.fill"
        ),
        PremiumFeature(
            title: "Profile Customization",
            description: "Unlock premium profile themes and badges",
            icon: "person.crop.circle.fill.badge.checkmark"
        ),
        PremiumFeature(
            title: "Ad-Free Experience",
            description: "Enjoy the game without interruptions",
            icon: "hand.raised.fill"
        ),
        PremiumFeature(
            title: "Priority Access",
            description: "Get early access to new content and features",
            icon: "crown.fill"
        )
    ]
}

struct PremiumFeature: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
} 