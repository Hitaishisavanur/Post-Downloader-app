import UIKit
import SwiftUI

class ShareViewController: UIViewController {
    @Published private var sharedURL: String?
    private let settingsViewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Extract the shared URL from the share extension context
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
           let attachment = item.attachments?.first,
           attachment.hasItemConformingToTypeIdentifier("public.url") {
            attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                if let url = url as? URL {
                    self.sharedURL = url.absoluteString
                    DispatchQueue.main.async {
                        self.setupHostingController()
                    }
                }
            }
        } else {
            setupHostingController()
        }
    }

    private func setupHostingController() {
//        let downloadViewModel = DownloadViewModel(url: sharedURL)
        let rootView = NavigationView {
            ShareView(sharedURL: sharedURL)
                .environmentObject(settingsViewModel)
                .navigationBarItems(leading: Button("Cancel") {
                    self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                })
        }

        let hostingController = UIHostingController(rootView: rootView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
}


struct ShareView: View {
    @State var sharedURL: String?
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        if sharedURL != nil {
            DownloadCardView(viewModel: DownloadViewModel(),url: sharedURL)
        } else {
            Text("No URL provided")
        }
    }
}
