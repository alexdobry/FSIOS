//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

CGFloat(1.0)
CGPoint(x: 100, y: 100) //
CGSize(width: 50, height: 50)
CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 50, height: 50))

@IBDesignable
class CustomView: UIView {
    
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        let t = type(of: self)
        let b = Bundle(for: t)
        let nib = UINib(nibName: String(describing: t), bundle: b)
        
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            contentView = view
            contentView.frame = bounds
            addSubview(contentView)
        } else {
            fatalError("cant instantiate custom view form nib")
        }
    }
}

class DrawingCustomView: UIView {
    
    override init(frame: CGRect) { // init from code
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) { // init from storyboard
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() { backgroundColor = UIColor.blue.withAlphaComponent(0.2) }
    
    override func draw(_ rect: CGRect) { // 'rect' is used for delta drawing (optimization)
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0) // draw rounded rect
        roundedRect.move(to: CGPoint(x: 10, y: 0))
        roundedRect.addLine(to: CGPoint(x: bounds.minX + 10, y: bounds.maxY)) // draw line on the left
        roundedRect.move(to: CGPoint(x: bounds.maxX - 10, y: bounds.maxY))
        roundedRect.addLine(to: CGPoint(x: bounds.maxX - 10, y: 0)) // draw line on the right
        
        UIColor.red.setStroke(); roundedRect.stroke()
        
        let arc = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 30.0, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true) // draw arc
        arc.lineWidth = 5.0
        
        UIColor.white.setStroke(); arc.stroke()
        UIColor.blue.setFill(); arc.fill()
    }
}

class DrawingViewController: UIViewController {
    
    var customView: DrawingCustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        customView = DrawingCustomView(
            frame: CGRect(x: 50, y: 50, width: 100, height: 100)
        )
        
        customView.frame // x: 50, y: 50, w: 100, h: 100
        customView.bounds // x: 0, y: 0, w: 100, h: 100
        
        customView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        
        view.addSubview(customView)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        customView?.setNeedsDisplay() // redraw by forcing draw()
    }
}

class MyViewController : UIViewController {
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view // superView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let position = CGRect(x: 100, y: 100, width: 250, height: 50)
        let label = UILabel(frame: position) // position of 'label'
        label.numberOfLines = 2
        label.text = "frame:\(label.frame)\nbounds:\(label.bounds)"
        label.textColor = .white
        label.backgroundColor = .red
        
        view.addSubview(label) // add 'label' as subView
    }
    
    // remove given 'subView' from superView
    func removeFromSuperView(subView: UIView) {
        subView.removeFromSuperview()
    }
}

class TodoView: UIView {}

class TodoViewController: UIViewController {
    
    let todoStackView = UIStackView()
    
    func addTodoButtonPressed() {
        let todoView = TodoView()
        todoView.isHidden = true // 'todoView' is hidden
        
        todoStackView.addArrangedSubview(todoView) // 'todoView' is still hidden
        
        UIView.animate(withDuration: 0.3, animations: {
            todoView.isHidden = false // interpolation of 'isHidden' property within 0.3s from 'isHidden = true' to 'isHidden = false'
        })
    }
}

class TraitCollectionDependentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
        case (.compact, .compact): print("landscape iphone 6 and above")
        case (.regular, .compact): print("portrait iphone 6 and above")
        case (.compact, .regular): print("portrait iphone plus")
        case (.regular, .regular): print("iPads")
        case _: print("something else ...")
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        print("called before traitCollectionDidChange(:) is called")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if let previousTraitCollection = previousTraitCollection {
            print("adjust views when device is rotated")
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = DrawingViewController()
