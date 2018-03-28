//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

func addMultipleSubviews(view : UIView, list : [UIView]) {
    for i in list {
        view.addSubview(i)
    }
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

        // Defines the coordinates of the dots dict
        let coords = [
            "p1": (10, 10),
            "p2": (100,100),
            "p3": (30, 150),
            "p4": (200,200)
        ]

        // Calls the function to create the UIView dict
        let dots = createDotz(coords)

        // Defines each dot neighbor
        let neighbors = [
            "p1": ["p2","p3"],
            "p2": [],
            "p3": ["p4"],
            "p4": []
        ]

        // Calls the function to create all paths
        let paths = createPaths(neighbors: neighbors, dots: dots)
        
        
        for i in dots {
            view.addSubview(i.value)
        }
        
//        view.layer.addSublayer(shapeLayer)
        for i in paths {
            for j in i.value {
                
                view.layer.addSublayer(j.value)
            }
        }
        
        
        self.view = view
    }
    
    // Creates the dots UIView dict
    func createDotz(_ list : [String : (Int,Int)]) -> [String : UIView] {
        
        var result = [String : UIView]()
        
        for dot in list.keys {
            let circulinho = UIView(frame: CGRect(x: list[dot]!.0, y: list[dot]!.1, width: 30, height: 30))
            circulinho.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            circulinho.layer.cornerRadius = circulinho.frame.width / 2
            
            result[dot] = circulinho
        }
        
        return result
        
    }
    
    // Creates the path of each dot to it's neighbors
    func createPaths(neighbors : [String : [String]], dots : [String : UIView])
        -> [String : [String : CAShapeLayer]] {
            
            var result = [String : [String : CAShapeLayer]]()
            
            for dot in dots {
                for neighbor in neighbors[dot.key]! {
                    
                    let path = UIBezierPath()
                    path.move(to: dot.value.center)
                    path.addLine(to: dots[neighbor]!.center)
                    print("\(dot.value.center), \(dots[neighbor]!.center)\n")
                    
                    let layer = CAShapeLayer()
                    layer.path = path.cgPath
                    
                    layer.lineWidth = 5.0
                    layer.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor
                    
                    if let _ = result[dot.key] {
                        result[dot.key]![neighbor] = layer
                    } else {
                        result[dot.key] = [:]
                        result[dot.key]![neighbor] = layer
                    }
                    
                }
            }
            
            return result
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()




