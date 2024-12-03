import MessageUI
import SwiftUI
import UIKit

class SupportManager: NSObject, ObservableObject, MFMailComposeViewControllerDelegate {
    static let shared = SupportManager()
    let supportEmail = "triviaholic.assist@gmail.com"
    let instagramHandle = "triviaholic_verse"
    
    @Published var isShowingMailView = false
    @Published var alertMessage: String?
    @Published var newsletterMessage: String?
    
    func sendSupportEmail(subject: String = "Triviaholic Support") {
        guard MFMailComposeViewController.canSendMail() else {
            alertMessage = "Please configure your email account in the Mail app to send support requests."
            return
        }
        
        // Get the key window's root view controller
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.keyWindow,
              let rootViewController = keyWindow.rootViewController?.presentedViewController ?? keyWindow.rootViewController else {
            print("No root view controller found")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([supportEmail])
        mailComposer.setSubject(subject)
        
        // Add device and app info to the email body
        let deviceInfo = """
        
        ----------
        Device Info:
        App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")
        Device: \(UIDevice.current.model)
        iOS Version: \(UIDevice.current.systemVersion)
        """
        
        mailComposer.setMessageBody(deviceInfo, isHTML: false)
        
        DispatchQueue.main.async {
            rootViewController.present(mailComposer, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print("Mail composer error: \(error.localizedDescription)")
        }
        controller.dismiss(animated: true)
    }
    
    func openInstagramPage() {
        // Try to open Instagram app first
        let instagramAppURL = URL(string: "instagram://user?username=\(instagramHandle)")!
        let instagramWebURL = URL(string: "https://instagram.com/\(instagramHandle)")!
        
        if UIApplication.shared.canOpenURL(instagramAppURL) {
            UIApplication.shared.open(instagramAppURL)
        } else {
            // If Instagram app is not installed, open in web browser
            UIApplication.shared.open(instagramWebURL)
        }
    }
    
    func contactSupport() {
        sendSupportEmail()
    }
    
    func handleNewsletterToggle(isSubscribed: Bool) {
        if isSubscribed {
            handleNewsletterSubscription(isSubscribing: true)
        } else {
            handleNewsletterSubscription(isSubscribing: false)
        }
    }
    
    private func handleNewsletterSubscription(isSubscribing: Bool) {
        // Prepare email content
        let subject = isSubscribing ? "New Newsletter Subscription" : "Newsletter Unsubscription"
        let body = """
        \(isSubscribing ? "New Newsletter Subscription" : "Newsletter Unsubscription")
        
        Date: \(Date())
        Device: \(UIDevice.current.model)
        iOS Version: \(UIDevice.current.systemVersion)
        App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")
        """
        
        // Show feedback to user
        DispatchQueue.main.async {
            self.newsletterMessage = isSubscribing ? 
                "Successfully subscribed to newsletter!" :
                "Successfully unsubscribed from newsletter"
            
            // Send email using mailto URL scheme
            self.sendMailtoEmail(subject: subject, body: body)
            
            // Clear the message after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.newsletterMessage = nil
            }
        }
    }
    
    private func sendMailtoEmail(subject: String, body: String) {
        // Create mailto URL
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = supportEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]
        
        if let emailUrl = components.url {
            // Open mail app in background
            UIApplication.shared.open(emailUrl, options: [:]) { success in
                if !success {
                    print("Failed to open mail app")
                }
            }
        }
    }
}
