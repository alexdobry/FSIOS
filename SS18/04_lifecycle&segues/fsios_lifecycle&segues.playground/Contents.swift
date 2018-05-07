//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

struct Model {
    let message: String
    let imageUrl: URL
}

func downloadImage(by url: URL, completion: (UIImage) -> ()) {
    completion(UIImage()) // fake image
}

class LifecycleViewController : UIViewController {
    
    var model: Model? // 1. set in preparation if being segued
    
    var label: UILabel? // 2. outlets, set by the storyboard
    var imageView: UIImageView?
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() { // 3. preparation is finished and outlets are set. best place for init code
        super.viewDidLoad()
        
        label?.textColor = .white
        imageView?.contentMode = .scaleAspectFill
        spinner?.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) { // 4. vc is about to be displayed on screen. show user content. 'viewDidAppear' is called after
        super.viewWillAppear(animated)
        guard let model = model else { return }
        
        label?.text = model.message
        spinner?.startAnimating()
        
        downloadImage(by: model.imageUrl) { image in
            self.imageView?.image = image
            self.spinner?.stopAnimating()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) { // At some point the device is rotated
        super.viewWillTransition(to: size, with: coordinator)
        imageView?.contentMode = size.width > size.height ? .scaleAspectFit : .scaleAspectFill
    }
    
    override func viewWillDisappear(_ animated: Bool) { // At some point the vc will be removed from screen. clean up or undo `willViewAppear`. `viewDidDisappear` is called after
        super.viewWillDisappear(animated)
        spinner?.stopAnimating() // just in case
    }
}

class BadLifecycleViewController : UIViewController {
    
    var model: Model? {
        didSet {
            label.text = model!.message // will crash, because outlets are implicitly unwrapped (which is done by default when using storyboards)
        }
    }
    
    @IBOutlet weak var label: UILabel! {
        didSet {
            label.textColor = .white // this should be fine, because `label` is just set
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nothing to do here
        
        modalPresentationStyle
    }
}

class DetailViewController: UIViewController {}

class DetailSegueViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Show Detail", style: .plain, target: self, action: #selector(showDetail(_:)))
    }
    
    @objc func showDetail(_ barButton: UIBarButtonItem) {
        showBySegue(barButton) // show detail vc by using segues
        showByNavigationController(barButton) // show detail vc by pushing onto navigationController stack
    }
    
    private func showBySegue(_ barButton: UIBarButtonItem) { // setup detail segue in storyboard
        performSegue(withIdentifier: "Show Detail Identifier", sender: barButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // prepare detail vc when using segues
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "Show Detail Identifier":
            let destinationViewController = segue.destination as! DetailViewController
            destinationViewController.title = (sender as! UIBarButtonItem).title
            
        default: break
        }
    }
    
    private func showByNavigationController(_ barButton: UIBarButtonItem) { // show and prepare detail vc when using navigationController
        guard let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerStoryboardID") as? DetailViewController else { return }
        
        destinationViewController.title = barButton.title
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

class PopoverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Show Modal", style: .plain, target: self, action: #selector(showModal(_:)))
    }
    
    @objc func showModal(_ barButton: UIBarButtonItem) {
        showBySegue(barButton) // just change from modal to popover...
        showByPresenting(barButton)
    }
    
    private func showBySegue(_ barButton: UIBarButtonItem) { // nothing new here
        performSegue(withIdentifier: "Show Detail Identifier", sender: barButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // nothing new here
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "Show Detail Identifier":
            let destinationViewController = segue.destination as! DetailViewController
            destinationViewController.title = (sender as! UIBarButtonItem).title
            
        default: break
        }
    }
    
    private func showByPresenting(_ barButton: UIBarButtonItem) {
        guard let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerStoryboardID") as? DetailViewController else { return }
        
        destinationViewController.title = barButton.title
        
        destinationViewController.modalPresentationStyle = .popover // change to popover
        destinationViewController.popoverPresentationController?.barButtonItem = barButton // change source where arrow points to
        
        present(destinationViewController, animated: true, completion: nil) // dismiss modal vc by calling `presentingViewController?.dismiss(animated: true, completion: nil)`
    }
}

class SrcViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSegue(withIdentifier: "Some Identifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Some Identifier", let destViewController = segue.destination as? UnwindingViewController else { return }
        destViewController.model = "new model from SrcViewController"
    }
    
    @IBAction func unwindFromDestViewController(_ segue: UIStoryboardSegue) { // this is called on srcViewController when unwinding happens
        guard let srcViewController = segue.source as? UnwindingViewController else { return }
        print(srcViewController.model)
    }
}

class UnwindingViewController: UIViewController {
    
    var model: String? // set by srcViewController first, updated later on
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    @objc func done() {
        performSegue(withIdentifier: "Unwind Segue", sender: self) // setup unwind segue in storyboard first ...
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Unwind Segue" else { return }
        model = "updated model from DestViewController"
    }
}

class ViewControllerToReuse: UIViewController { }

class EmbedSegueViewController: UIViewController {
    
    var viewControllerToReuse: ViewControllerToReuse?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier = "Embed Segue" else { return }
        
        viewControllerToReuse = segue.destination as? ViewControllerToReuse
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = LifecycleViewController()
