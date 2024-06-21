//
//  ShareViewController.swift
//  ShareExtensions
//
//  Created by Hitaishi Savanur on 20/06/24.
//

import UIKit
import SwiftUI

class ShareViewController: UIViewController {
    @Published private var sharedURL: String?
    

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
                .navigationBarItems(leading: Button("Cancel") {
                    self.closer()
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
    func closer(){
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}


struct ShareView: View {
    @State var sharedURL: String?
    

    var body: some View {
        if sharedURL != nil {
            DownloadCardView(viewModel: DownloadViewModel(),url: sharedURL)
        } else {
            Text("No URL provided")
        }
    }
}
