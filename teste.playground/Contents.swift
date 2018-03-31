//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

var maxTag = -1

public class MyViewController : UIViewController {
    
    public override func loadView() {

        let view = UIView()
        view.backgroundColor = .white
        
        // Import font
        let furl = Bundle.main.url(forResource: "IndieFlower", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(furl, CTFontManagerScope.process, nil)
        let font = UIFont(name: "IndieFlower", size: 15)
        
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
        textBox.font = font!
        
        
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
        
        let op = createOptions(choices: choices, font: font!)
        for i in op["p1"]! {
            choosingBox.addSubview(i.value)
        }
        
        upperView.addSubview(textBox)
        upperView.addSubview(choosingBox)
        
        
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
    
    // Creates the UILabel for the options
    func createOptions(choices: [String : [String : String]], font: UIFont) -> [String : [String : UIButton]]{
        
        var result = [String : [String : UIButton]]()
        
        for dot in choices {
            var cont = 0
            for choice in dot.value {
                
                let btn = UIButton(frame: CGRect(x: (620 / dot.value.count) * cont, y: 0, width: (620 / dot.value.count), height: 50))
                btn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                btn.layer.borderWidth = 2.0
                btn.layer.borderColor = UIColor.black.cgColor
                btn.setTitle(choice.value, for: .normal)
                btn.titleLabel?.textAlignment = .center
                btn.titleLabel?.numberOfLines = 0
                btn.titleLabel?.font = font
                btn.tag = Int(choice.key.dropFirst(1))!
                maxTag = max(btn.tag, maxTag)
                btn.addTarget(self, action: #selector(nextText), for: .touchUpInside)
                
                cont += 1
                
                if let _ = result[dot.key] {
                    result[dot.key]![choice.key] = btn
                } else {
                    result[dot.key] = [:]
                    result[dot.key]![choice.key] = btn
                }
                
            }
        }
        
        return result
        
    }
    // TODO - AJEITAR ESSA PORRA OS BOTAO E TAL
    // Action of the button
    @objc func nextText(sender : UIButton!) {
        switch(sender.tag) {
        case 2:
            print("EOQ")
        default:
            break
        }
    }
    
    
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





