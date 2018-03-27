//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

func addMultipleSubviews(view : UIView, list : [UIView]) {
    for i in list {
        view.addSubview(i)
    }
}

func createDotz(_ list : [(Int,Int)]) -> [UIView] {

    var result : [UIView] = []
    
    for i in list {
        let circulinho = UIView(frame: CGRect(x: i.0, y: i.1, width: 100, height: 100))
        circulinho.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        circulinho.layer.cornerRadius = circulinho.frame.width / 2
        
        result.append(circulinho)
    }
    
    return result
    
}

//func drawLine(_ p1 : CGPoint, _ p2 : CGPoint) -> [] {
//
//
//
//}


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let dotz : [String ]
        
        let ballz = createDotz(labels)
        
        
        let path = UIBezierPath()
        path.move(to: ballz[0].center)
        path.addLine(to: ballz[1].center)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        view.layer.addSublayer(shapeLayer)
        for i in ballz {
            view.addSubview(i)
        }
        self.view = view
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
