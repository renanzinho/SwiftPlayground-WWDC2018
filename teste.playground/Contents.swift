//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    override func loadView() {

        let view = UIView()
        view.backgroundColor = .white
        
        // Import font
//        let generalFont = UIFont(name: "TrebuchetMS", size: 15)
        let ofurl = Bundle.main.url(forResource: "IndieFlower", withExtension: "ttf") as! CFURL
        CTFontManagerRegisterFontsForURL(ofurl, CTFontManagerScope.process, nil)
        let optionsFont = UIFont(name: "IndieFlower", size: 15)
        
        let generalFont = UIFont(name: "TrebuchetMS", size: 15)
        
        // Creates the view for the texts
        let upperView = UIView(frame: CGRect(x: 0, y: 0, width: 640, height: 300))
        upperView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        // Creates the view for the graph
        let lowerView = UIView(frame: CGRect(x: 0, y: 300, width: 640, height: 180))
        lowerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        view.addSubview(upperView)
        view.addSubview(lowerView)
        
        // UPPER BODY
        
        // Defines the texts template
        let texts = [
            "t1": """
        ERA UMA VEZ uma linda menina que vivia no bosque e a quem todos chamavam, carinhosamente, de capuchinho vermelho.
        
        Um dia a mãe chamou-a e pediu-lhe um favor:
        
        - Coloquei neste cesto um bolo e um pote de mel. Leva-o à avozinha, que tem andado adoentada. Mas Capuchinho, tem cuidado! Não te desvies do teu caminho e não fales com desconhecidos.
        
        - Sim mãe, farei como dizes - prometeu Capuchinho Vermelho.
        """
        ]
        
        
        
        let textBox = UILabel(frame: CGRect(x: 10, y: 10, width: 620, height: 220))
        textBox.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        textBox.text = texts["t1"]!
        textBox.textColor = .white
        textBox.numberOfLines = 0
        textBox.textAlignment = .left
        textBox.font = generalFont!
        
        
        let choosingBox = UIView(frame: CGRect(x: 10, y: 230, width: 620, height: 50))
        choosingBox.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        let choices = [
            "p1": [
                "p2": "vou pela floresta",
                "p3": "vou pela estrada mais longa",
                "p4": "eoq"
            ],
            "p2": [:]
        ]
        
        let c1Label = UILabel(frame: CGRect(x: (620 / choices["p1"]!.count) * 0, y: 0, width: (620 / choices["p1"]!.count), height: 50))
        c1Label.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        c1Label.text = choices["p1"]!["p2"]!
        c1Label.textAlignment = .center
        c1Label.numberOfLines = 0
        c1Label.font = optionsFont!
        
        let c2Label = UILabel(frame: CGRect(x: (620 / choices["p1"]!.count) * 1, y: 0, width: (620 / choices["p1"]!.count), height: 50))
        c2Label.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        c2Label.text = choices["p1"]!["p3"]!
        c2Label.textAlignment = .center
        c2Label.numberOfLines = 0
        c2Label.font = optionsFont!
        
        upperView.addSubview(textBox)
        upperView.addSubview(choosingBox)
        choosingBox.addSubview(c1Label)
        choosingBox.addSubview(c2Label)
        
        // LOWER BODY
        
        // Text for each dot
        let dotsText = [
            "p1": texts["t1"]!,
            "p2": "",
            "p3": "",
            "p4": ""
        ]
        
        // Defines the coordinates of the dots dict
        let coords = [
            "p1": (10, 10),
            "p2": (100,100),
            "p3": (30, 140),
            "p4": (50 ,100)
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
    
//    // Creates the UILabel for the options
//    func createOptions(_ : [String : [String : String]]) -> [String : [String : UILabel]]{
//        
//    }
    
    
    // Creates the dots UIView dict
    func createDotz(_ list : [String : (Int,Int)]) -> [String : UIView] {
        
        var result = [String : UIView]()
        
        for dot in list {
            let circulinho = UIView(frame: CGRect(x: dot.value.0, y: dot.value.1, width: 20, height: 20))
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
                    
                    layer.lineWidth = 4.0
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
controller.preferredContentSize = CGSize(width: 640, height: 480)

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = controller





