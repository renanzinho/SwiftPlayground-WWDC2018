//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

var maxTag = -1

public class MyViewController : UIViewController {
    
    // Defines the main texts for each dot
    public let dotsTexts = [
        "p1": """
        ERA UMA VEZ uma linda menina que vivia no bosque e a quem todos chamavam, carinhosamente, de capuchinho vermelho.
        
        Um dia a mãe chamou-a e pediu-lhe um favor:
        
        - Coloquei neste cesto um bolo e um pote de mel. Leva-o à avozinha, que tem andado adoentada. Mas Capuchinho, tem cuidado! Não te desvies do teu caminho e não fales com desconhecidos.
        
        - Sim mãe, farei como dizes - prometeu Capuchinho Vermelho.
        """,
        "p2": "ALO?",
        "p3": "",
        "p4": ""
    ]
    
    // Defines each option's text
    let choices = [
        "p1": [
            "p2": "vou pela floresta",
            "p3": "vou pela estrada mais longa",
            "p4": "eoq"
        ],
        "p2": [:]
    ]
    
    // Defines the coordinates of each dot
    let coords = [
        "p1": (10, 10),
        "p2": (100,100),
        "p3": (30, 140),
        "p4": (50 ,100)
    ]
    
    // Defines each dot's neighbor
    let neighbors = [
        "p1": ["p2","p3"],
        "p2": ["p4"],
        "p3": ["p4"],
        "p4": []
    ]
    
    
    public var options = [String : [String : UIButton]]()
    public var paths = [String : [String : CAShapeLayer]]()
    public var dots = [String : UIView]()
    public let textBox = UILabel()
    public let upperView = UIView()
    public let lowerView = UIView()
    public let choosingBox = UIView()
    
    public override func loadView() {
        
        let view = UIView()
        view.backgroundColor = .white
        
        // Import font
        let furl = Bundle.main.url(forResource: "IndieFlower", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(furl, CTFontManagerScope.process, nil)
        let font = UIFont(name: "IndieFlower", size: 15)
        
        // Creates the view for the texts
        self.upperView.frame = CGRect(x: 0, y: 0, width: 640, height: 300)
        self.upperView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        // Creates the view for the graph
        self.lowerView.frame = CGRect(x: 0, y: 300, width: 640, height: 180)
        self.lowerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        view.addSubview(self.upperView)
        view.addSubview(self.lowerView)
        
        // UPPER BODY
        
        self.textBox.frame = CGRect(x: 10, y: 10, width: 620, height: 220)
        self.textBox.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.textBox.text = self.dotsTexts["p1"]!
        self.textBox.textColor = .white
        self.textBox.numberOfLines = 0
        self.textBox.textAlignment = .left
        self.textBox.font = font!
        self.textBox.sizeToFit()
        
        self.choosingBox.frame = CGRect(x: 10, y: 230, width: 620, height: 50)
        self.choosingBox.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        self.options = createOptions(choices: self.choices, font: font!)
        for i in self.options["p1"]! {
            choosingBox.addSubview(i.value)
        }
        
        upperView.addSubview(textBox)
        upperView.addSubview(choosingBox)
        
        
        // LOWER BODY

        // Calls the function to create the UIView dict
        self.dots = createDotz(self.coords)

        // Calls the function to create all paths
        self.paths = createPaths(neighbors: self.neighbors, dots: self.dots)
        
        // Teste criando todos os pontos e paths
        for i in self.dots {
            lowerView.addSubview(i.value)
        }
        for i in self.paths {
            for j in i.value {
                lowerView.layer.addSublayer(j.value)
            }
        }
        
        self.view = view
    }
    
    // Handles view changes
    func changeView(_ dot : String) {
        
        UIView.animate(withDuration: 2, animations: {
            self.textBox.alpha = 0.0
        }, completion: {
            (value: Bool) in
            self.textBox.text = self.dotsTexts[dot]!
            UIView.animate(withDuration: 2, animations: {
                self.textBox.alpha = 1.0
            })
        })
    }
    
    
    // Creates the UIButtons for the options
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
            print("ALO")
        }
    }
    
    
    // Creates the dots UIView dict
    func createDotz(_ list : [String : (Int,Int)]) -> [String : UIView] {
        
        var result = [String : UIView]()
        
        for dot in list {
            let circulinho = UIView(frame: CGRect(x: dot.value.0, y: dot.value.1, width: 20, height: 20))
            circulinho.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
                    layer.strokeColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
                    
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





