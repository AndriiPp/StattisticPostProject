//
//  ViewController.swift
//  StattisticPostProject
//
//  Created by Andrii Pyvovarov on 1/23/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum Choise: Int {
    case ID = 0
    case Like = 1
    case Comment = 2
    case Mentione = 3
    case Repost = 4
}


class MainViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    
    var cellId = "cell"
    @IBOutlet weak var ViewLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    @IBOutlet weak var LikeCV: UICollectionView!
    @IBOutlet weak var CommentLabel: UILabel!
    @IBOutlet weak var CommCV: UICollectionView!
    @IBOutlet weak var ManLabel: UILabel!
    @IBOutlet weak var ManCV: UICollectionView!
    @IBOutlet weak var RepostLabel: UILabel!
    @IBOutlet weak var repostCV: UICollectionView!
    @IBOutlet weak var MarkLabel: UILabel!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LikeCV.delegate = self
        LikeCV.dataSource = self
        
        CommCV.delegate = self
        CommCV.dataSource = self
        
        ManCV.delegate = self
        ManCV.dataSource = self
        
        repostCV.delegate = self
        repostCV.dataSource = self
        
        LikeCV.register(CollectionCell.self, forCellWithReuseIdentifier: cellId)
        CommCV.register(CollectionCell.self, forCellWithReuseIdentifier: cellId)
        ManCV.register(CollectionCell.self, forCellWithReuseIdentifier: cellId)
        repostCV.register(CollectionCell.self, forCellWithReuseIdentifier: cellId)
        
        apiRequest(url: url, parameters: ["slug" : slug], choise: .ID)
    }

    override func viewWillAppear(_ animated: Bool) {
        navBar()
    }
    func navBar(){
        navigationItem.title = "inrating.top"
        let nav =  self.navigationController?.navigationBar
        nav?.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "GujaratiSangamMN-Bold", size: 16)!]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateData))
        
    }
    func apiRequest(url: String,  parameters: [String: String]?, choise: Choise)  {
        let header = ["Authorization": "Bearer \(token)"]
        request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                print(json)
                switch choise {
                case .ID:
                    let id = self.ID(json: json)
                    self.apiRequest(url: like, parameters: ["id" : id], choise: .Like)
                    self.apiRequest(url: repost, parameters: ["id": id], choise: .Repost)
                    self.apiRequest(url: comment, parameters: ["id" : id], choise: .Comment)
                    self.apiRequest(url: mentione, parameters: ["id" : id], choise: .Mentione)
                default : self.GetHumans(json: json, row: choise.rawValue)
                }
            } 
    }
    }
    
    
    func ID(json : JSON) -> String{
        MarkLabel.text = "Закладки : " + json["bookmarks_count"].stringValue
        RepostLabel.text = "Репосты : " + json["reposts_count"].stringValue
        ViewLabel.text = "Просмотры : " + json["views_count"].stringValue
        LikeLabel.text = "Лайки : " + json["likes_count"].stringValue
        ManLabel.text = "Отметки : " + json["attachments"]["images"][0]["mentioned_users_count"].stringValue
        
          return json["id"].stringValue
    }
    
    func GetHumans(json : JSON, row : Int){
        let data = json["data"].arrayValue
        for i in 0..<data.count {
            let image = data[i]["avatar_image"]["url_medium"].stringValue
            let name = data[i]["nickname"].stringValue
            Human.humans[row].append(Human(name: name, image: image))
        }
        
        switch row {
        case 1:
            if Human.humans[1].count != 0 {
                LikeCV.isHidden = false
            }
            DispatchQueue.main.async {
                self.LikeCV.reloadData()
            }
        case 2:
            if Human.humans[2].count != 0 {
                CommCV.isHidden = false
            }
            DispatchQueue.main.async {
                self.CommCV.reloadData()
            }
        case 3:
            if Human.humans[3].count != 0 {
                ManCV.isHidden = false
            }
            DispatchQueue.main.async {
                self.ManCV.reloadData()
            }
        case 4:
            if Human.humans[4].count != 0 {
                repostCV.isHidden = false
            }
            DispatchQueue.main.async {
                self.repostCV.reloadData()
            }
        default:
            break
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    @objc func updateData(){
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case LikeCV:
            return Human.humans[1].count
        case CommCV:
            CommentLabel.text = "Коментаторы : \(Human.humans[2].count)"
            return Human.humans[2].count
        case ManCV:
            return Human.humans[3].count
        case repostCV:
            return Human.humans[4].count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionCell
        switch collectionView {
        case LikeCV:
             cell.configure(at: indexPath, collectionViewNumber: 1)
        case CommCV:
             cell.configure(at: indexPath, collectionViewNumber: 2)
        case ManCV:
             cell.configure(at: indexPath, collectionViewNumber: 3)
        case repostCV:
             cell.configure(at: indexPath, collectionViewNumber: 4)
        default:
            break
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 96, height: 110)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Human.humans[indexPath.section].count == 0 {
            return 54
        } else {
            return 170
        }
    }
    
}
