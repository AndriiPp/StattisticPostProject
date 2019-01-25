//
//  CollectionCell.swift
//  StattisticPostProject
//
//  Created by Andrii Pyvovarov on 1/23/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

import UIKit
import Alamofire

class CollectionCell: UICollectionViewCell {
    let profileImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentMode = .scaleAspectFill
        imageV.layer.masksToBounds = true
        imageV.layer.cornerRadius = 7
        return imageV
    }()
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    func configure(at indexPath: IndexPath, collectionViewNumber: Int) {
        nameLabel.text = Human.humans[collectionViewNumber][indexPath.row].name
        Alamofire.request(Human.humans[collectionViewNumber][indexPath.row].image).response { response in
            self.profileImageView.image = UIImage(data: response.data!)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(nameLabel)
        
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
