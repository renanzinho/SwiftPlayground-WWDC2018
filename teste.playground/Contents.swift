//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    override func loadView() {

        let view = UIView()
        view.backgroundColor = .white
        
        // Creates the view for the texts
        let upperView = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 450))
        upperView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        // Creates the view for the graph
        let lowerView = UIView(frame: CGRect(x: 0, y: 450, width: 1024, height: 318))
        lowerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        view.addSubview(upperView)
        view.addSubview(lowerView)
        
        // Defines the coordinates of the dots dict
        let coords = [
            "p1": (10, 10),
            "p2": (100,100),
            "p3": (30, 150),
            "p4": (200,200)
        ]

        // Calls the function to create the UIView dict
        let dots = createDotz(coords)

        // Defines each dot's neighbor
        let neighbors = [
            "p1": ["p2","p3"],
            "p2": [],
            "p3": ["p4"],
            "p4": []
        ]

        // Calls the function to create all paths
        let paths = createPaths(neighbors: neighbors, dots: dots)
        
        // Teste criando todos os pontos e paths
        for i in dots {
            lowerView.addSubview(i.value)
        }
        for i in paths {
            for j in i.value {
                lowerView.layer.addSublayer(j.value)
            }
        }
        
        
        self.view = view
    }
    
    // Creates the dots UIView dict
    func createDotz(_ list : [String : (Int,Int)]) -> [String : UIView] {
        
        var result = [String : UIView]()
        
        for dot in list {
            let circulinho = UIView(frame: CGRect(x: dot.value.0, y: dot.value.1, width: 30, height: 30))
            circulinho.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            circulinho.layer.cornerRadius = circulinho.frame.width / 2
            
            result[dot.key] = circulinho
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

let controller = MyViewController()
controller.preferredContentSize = CGSize(width: 1024, height: 768)

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = controller





