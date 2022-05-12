//
//  quoteViewController.swift
//  TestMarmelade
//
//  Created by Samy Boussair on 09/05/2022.
//

import UIKit



class quoteViewController: UIViewController {
    
    
    
    
//    MARK: Variable
    
    var End: Bool = false
    var ProgressNumber = 0
    var QuotePourcentage = "0 %"
    var buttonLabel: String = "CITATION SUIVANTE"
    var buttonLabelEnd: String = "FINIR"
    var AuthorLabel: String = "AUTHOR"
    var QuoteLabel: String = "QUOTE"


    
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
        ProgressNumber += 10
        pourcentageProgress.text = "\(ProgressNumber) % "
            if  ProgressNumber == 50 {
                Alert()
        }
    }
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
            ProgressNumber = 0
            pourcentageProgress.text = "0 % "
            button.setTitle("CITATION SUIVANTE", for: .normal)
            authorLabel.text = AuthorLabel
            quoteLabel.text = QuoteLabel
            End = false
        }
        
        // MARK: fonction qui chek le slider pour modifier les smiley ( changer pour le pourcentage de bonne reponse)

        
        func checkProgress() {
            
            if ProgressNumber < 20 {
                smileyProgress.image =  UIImage(named: "smiley_sick.png")
            } else if ProgressNumber > 20 && ProgressNumber < 60 {
                smileyProgress.image = UIImage(named: "smiley_meh.png")
            } else if ProgressNumber > 60 {
                smileyProgress.image =  UIImage(named: "smiley_awe.png")
            }
            if ProgressNumber == 100 {
                End = true
                button.setTitle("FINIR", for: .normal)
                ProgressNumber = -10
            }
        }
    

    
    // MARK: fonction pour L'arlert a 50% et a la fin
    
    func Alert() {
        let alert = UIAlertController(title: "Tu est a 50% des citations", message: " Tu as bientot fini! ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continuer", style: .cancel, handler: { action in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Arrêter", style: .destructive, handler: {(alert: UIAlertAction!)
             in self.resetProgress()

        }))
        present(alert, animated: true)
    }
}


