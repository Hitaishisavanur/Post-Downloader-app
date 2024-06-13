

import SwiftUI

struct ZoomableImageViewControllerRepresentable: UIViewControllerRepresentable {
    
    var image: UIImage?

    func makeUIViewController(context: Context) -> ZoomableImageViewController {
        let viewController = ZoomableImageViewController()
        viewController.image = image
        return viewController
    }

    func updateUIViewController(_ uiViewController: ZoomableImageViewController, context: Context) {
        uiViewController.image = image
    }
}

