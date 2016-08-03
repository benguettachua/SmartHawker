import UIKit

class ContainerViewController: UIViewController {
    @IBOutlet weak var containerViewA: UIView!
    @IBOutlet weak var containerViewB: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("lalala")
    }
    
    @IBAction func showComponent(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.25, animations: {
                self.containerViewA.alpha = 1
                self.containerViewB.alpha = 0
            })
        } else {
            UIView.animateWithDuration(0.25, animations: {
                self.containerViewA.alpha = 0
                self.containerViewB.alpha = 1
            })
        }
    }
}