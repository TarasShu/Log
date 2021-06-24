//
//  MovieCell.swift
//  Log
//
//  Created by Taras Shukhman on 24/06/2021.
//


import Foundation
import UIKit

class MovieCell: UITableViewCell  {
    
    var movie: Movies? {
        didSet{
            guard let movie = movie else { return }
            titlLabel.text = movie.title
            retingLable.text = String(movie.rating)
            yearLabel.text = String(movie.releaseYear)
            genreLabel.text = movie.genre.joined(separator: ", ")
                
            let url = movie.image
            imagePoster.loadCasheWith(url, placeHolder: UIImage(named: "placeholder"))
            
        }
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
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        return img
    }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = cellMovieColor
        set()
    }
    
    func set(){
        addSubview(titlLabel)
        addSubview(imagePoster)
        addSubview(yearLabel)
        addSubview(retingLable)
        addSubview(genreLabel)
        
        NSLayoutConstraint.activate([
          
            imagePoster.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imagePoster.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            imagePoster.heightAnchor.constraint(equalToConstant: 130),
            imagePoster.widthAnchor.constraint(equalToConstant: 100),

            imagePoster.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            titlLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titlLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titlLabel.rightAnchor.constraint(equalTo: imagePoster.leftAnchor, constant: 10),

            yearLabel.topAnchor.constraint(equalTo: titlLabel.bottomAnchor, constant: 8),
            yearLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            yearLabel.bottomAnchor.constraint(equalTo: retingLable.topAnchor, constant: -8),

            retingLable.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            //retingLable.bottomAnchor.constraint(equalTo: bottomAnchor),
            retingLable.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 8),
            genreLabel.topAnchor.constraint(equalTo: retingLable.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            genreLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }
}
