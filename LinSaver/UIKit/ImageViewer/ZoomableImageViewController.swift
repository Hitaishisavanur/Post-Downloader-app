

import UIKit

class ZoomableImageViewController: UIViewController, UIScrollViewDelegate {

    

    var image: UIImage? {
        didSet {
            imgView.image = image
//            imageView.sizeToFit()
//            scrollView?.contentSize = imageView.frame.size
//            updateMinZoomScaleForSize(scrollView.bounds.size)
        }
    }

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var imgView: UIImageView = {
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.addSubview(imgView)
        
        NSLayoutConstraint.activate([
              scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
              scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
              scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
              scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

              imgView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
              imgView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
              imgView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
              imgView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
              imgView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
              imgView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1),

              
            ])
        addScrollViewZoomSetUp()
    }

    func addScrollViewZoomSetUp(){
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.setZoomScale(1, animated: true)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 2, height: scrollView.frame.size.height * 2)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    func addDoubleTapZoomGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc func handleDoubleTap(gesture:UITapGestureRecognizer){
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectforScale(scale: scrollView.maximumZoomScale, center: gesture.location(in: gesture.view )), animated: true)
        }else{
            scrollView.setZoomScale(1, animated: true)
        }
    }
    func zoomRectforScale(scale: CGFloat, center :CGPoint)-> CGRect{
        var zoomRect = CGRect.zero
        zoomRect.size.width = imgView.frame.size.width / scale
        zoomRect.size.height = imgView.frame.size.height / scale
        let center = imgView.convert(center, from: scrollView)
        zoomRect.origin.x = center.x -  (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y -  (zoomRect.size.height / 2)
        return zoomRect
    }
}

