import SwiftUI
import MessageUI

struct ShareSheet: UIViewControllerRepresentable {
    let text: String
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: ShareSheet
        
        init(_ parent: ShareSheet) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = context.coordinator
            composer.setSubject("Triviaholic Progress")
            
            // Format email body with HTML for better presentation
            let htmlBody = """
            <html>
            <body style="font-family: -apple-system, sans-serif; color: #333;">
                <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
                    <h1 style="color: #4A90E2; text-align: center;">🎮 Triviaholic Progress Report 🏆</h1>
                    
                    <div style="background: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;">
                        <h2 style="color: #2E1C4A; margin-bottom: 15px;">👤 Player Profile</h2>
                        <p style="margin: 5px 0;">\(text)</p>
                    </div>
                    
                    <hr style="border: 1px solid #eee; margin: 30px 0;">
                    
                    <p style="color: #666; font-size: 12px; text-align: center;">
                        Sent from Triviaholic App
                    </p>
                </div>
            </body>
            </html>
            """
            
            composer.setMessageBody(htmlBody, isHTML: true)
            return composer
        } else {
            // Fallback to regular share sheet
            let activityViewController = UIActivityViewController(
                activityItems: [text],
                applicationActivities: nil
            )
            return activityViewController
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
} 