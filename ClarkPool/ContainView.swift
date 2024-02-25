
import Foundation
import SwiftUI
class ContainView: UIViewController {

    @IBOutlet weak var theContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let childView = UIHostingController(rootView: HomeList())
        addChildViewController(childView)
        childView.view.frame = theContainer.bounds
        theContainer.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
