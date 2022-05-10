//
//  quoteViewController.swift
//  TestMarmelade
//
//  Created by Samy Boussair on 09/05/2022.
//

import UIKit



class quoteViewController: UIViewController {
    
    var End: Bool = false

    // MARK: Degrader background et bottomView

    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(red: 0.953, green: 0.816, blue: 0.329, alpha: 1).cgColor,
            UIColor(red: 0.953, green: 0.804, blue: 0.329, alpha: 1).cgColor,
            UIColor(red: 0.945, green: 0.761, blue: 0.329, alpha: 1).cgColor,
            UIColor(red: 0.937, green: 0.694, blue: 0.325, alpha: 1).cgColor,
            UIColor(red: 0.929, green: 0.6, blue: 0.325, alpha: 1).cgColor,
            UIColor(red: 0.914, green: 0.478, blue: 0.322, alpha: 1).cgColor,
            UIColor(red: 0.898, green: 0.337, blue: 0.318, alpha: 1).cgColor
          ]
        gradient.locations = [0.07, 0.27, 0.43, 0.59, 0.73, 0.87, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1.33, b: -1.17, c: 1.94, d: -0.65, tx: 0.41, ty: 1.49))
        gradient.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        gradient.position = view.center
        return gradient
    }()

    

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var smileyProgress: UIImageView!
    @IBOutlet weak var pourcentageProgress: UILabel!
    @IBOutlet weak var sliderProgress: UISlider!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientView.layer.addSublayer(gradient)
        bottomView.layer.cornerRadius = 12.0
       
        
        // appele de la fonction
        quoteAuthor()
        
        
    }
    
    
   
    
    // MARK: fonction pour afficher les quote et l'autheur
    
    func quoteAuthor () {
    Network.shared.apollo.fetch(query: QuoteQuery()) {result in
        switch result {
        case .success(let graphQLResult):
            DispatchQueue.main.async {
                let countResult = graphQLResult.data?.quotes.count
                let quoteIndex = Int.random(in: 0..<countResult!)
                if let quote = graphQLResult.data?.quotes {
                    self.quoteLabel.text = quote[quoteIndex].quote
                    self.authorLabel.text = quote[quoteIndex].author
                    
                }
            }
        case.failure(let error):
            print ("Error: \(error)")
        }
    }
}
    
    
  
    // MARK: Slider qui evolue
    
    @IBAction func slider(_ sender: UISlider) {
       
        var value = Int(sender.value)
    }
    
    
    
    
    // MARK: Fonction clique button
    
    @IBAction func buttonNextQuote(_ sender: Any) {
        if  End {
            resetProgress()
            sliderProgress.value = 0
        } else {
        nextQuoteAuthor()
        sliderProgress.value += 1
        checkProgress()
    }
        
        
    
    // MARK: Fonction button nouvele quote et autheur
    
    func nextQuoteAuthor() {
    //Prochaine quote et autheur
            quoteAuthor()
            
        }
    
        
        // MARK: fonction qui reset le programe

        func resetProgress() {
            sliderProgress.value = 0
            smileyProgress.image = UIImage(named: "smiley_sick.png")
            sliderProgress.value = 0.0
            
            End = false
        }
    
        
        // MARK: fonction qui chek le slider pour modifier les smiley ( changer pour le pourcentage de bonne reponse)

        
        func checkProgress() {
            
            if sliderProgress.value < 4 {
                smileyProgress.image =  UIImage(named: "smiley_sick.png")
            } else if sliderProgress.value > 4 && sliderProgress.value < 7 {
                smileyProgress.image = UIImage(named: "smiley_meh.png")
            } else if sliderProgress.value > 7 {
                smileyProgress.image =  UIImage(named: "smiley_awe.png")
            }
            if sliderProgress.value == 10 {
               End = true
                sliderProgress.value = -10
            }
        }
    }
    
    // MARK: fonction qui reset le slider

    func resetProgress() {
       
        sliderProgress.value = 0.0
        
    }
}
