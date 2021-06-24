//
//  DetailVC.swift
//  Log
//
//  Created by Taras Shukhman on 24/06/2021.
//



import UIKit
import CoreData

class DetailVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imagePoster)
        view.addSubview(yearLabel)
        view.addSubview(retingLable)
        view.addSubview(genreLabel)
        view.backgroundColor = .white
        set()
    }
    
    
    var movie: Movies? {
        didSet{
            guard let movie = movie else { return }
            titlLabel.text = movie.title
            retingLable.text = makeItFency(String(movie.rating))
            yearLabel.text = makeItFency(String(movie.releaseYear))
            genreLabel.text = movie.genre.joined(separator: ", ")
            title = titlLabel.text
            let url = movie.image
            imagePoster.loadCasheWith(url, placeHolder:  UIImage(named: "placeholder"))
        
        }
    }
    
    func makeItFency(_ str: String) -> String {
        return str.replacingOccurrences(of: "0", with: "0️⃣")
            .replacingOccurrences(of: "1", with: "1️⃣")
            .replacingOccurrences(of: "2", with: "2️⃣")
            .replacingOccurrences(of: "3", with: "3️⃣")
            .replacingOccurrences(of: "4", with: "4️⃣")
            .replacingOccurrences(of: "5", with: "5️⃣")
            .replacingOccurrences(of: "6", with: "6️⃣")
            .replacingOccurrences(of: "7", with: "7️⃣")
            .replacingOccurrences(of: "8", with: "8️⃣")
            .replacingOccurrences(of: "9", with: "9️⃣")
            .replacingOccurrences(of: ".", with: "")
    }

    private let genreLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let titlLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .headline)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
       // lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let retingLable: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let yearLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var imagePoster: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 10
        img.sizeToFit()
      
        
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        return img
    }()
    
    
    
    
    
    
    
    func set(){
        
        
        NSLayoutConstraint.activate([
            

            
            imagePoster.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            imagePoster.rightAnchor.constraint(equalTo:  self.view.layoutMarginsGuide.rightAnchor, constant: -2),
            imagePoster.leftAnchor.constraint(equalTo:  self.view.layoutMarginsGuide.leftAnchor, constant: 2),
            imagePoster.heightAnchor.constraint(equalToConstant: 300),
            
            
            yearLabel.topAnchor.constraint(equalTo: imagePoster.bottomAnchor, constant: 10),
            yearLabel.leftAnchor.constraint(equalTo:  self.view.leftAnchor, constant: 8),
            yearLabel.bottomAnchor.constraint(equalTo: retingLable.topAnchor, constant: -10),
//
            retingLable.leftAnchor.constraint(equalTo:  self.view.leftAnchor, constant: 8),
            retingLable.bottomAnchor.constraint(equalTo: genreLabel.topAnchor, constant: -10),
            retingLable.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 10),
            
            
            genreLabel.leadingAnchor.constraint(equalTo:  self.view.leadingAnchor, constant: 8),
            genreLabel.topAnchor.constraint(equalTo: retingLable.bottomAnchor, constant: 10)
        ])
    }
    
    

}
