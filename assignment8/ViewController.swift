//
//  ViewController.swift
//  assignment8
//
//  Created by user169339 on 5/29/20.
//  Copyright © 2020 user169339. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var restaurants = [
        Restaurant(name: "restaurant1", type: .type1),
        Restaurant(name: "restaurant2", type: .type2),
        Restaurant(name: "restaurant3", type: .type3),
        Restaurant(name: "restaurant4", type: .type4),
        Restaurant(name: "restaurant5", type: .type5),
        Restaurant(name: "restaurant6", type: .type6),
        Restaurant(name: "restaurant7", type: .type7),
        Restaurant(name: "restaurant8", type: .type8),
        Restaurant(name: "restaurant9", type: .type9),
        Restaurant(name: "restaurant10", type: .type10),
        Restaurant(name: "restaurant11", type: .type1),
        Restaurant(name: "restaurant12", type: .type1),
        Restaurant(name: "restaurant13", type: .type2),
    ]
    
    var filtered: [Restaurant] = []
    
    var types = [Restaurant.RestaurantType]()
    
    private var isSelected: [Bool] = [true, false, false, false, false, false, false, false, false, false, false ]
    
    var collectionView1: UICollectionView!
    var collectionView2: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Restaurants"
        
        let layout1 = UICollectionViewFlowLayout()
        collectionView2 = UICollectionView(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 100), collectionViewLayout: layout1)
        collectionView2.register(CollectionView1.self, forCellWithReuseIdentifier: "View1")
        layout1.scrollDirection = .horizontal
        layout1.minimumInteritemSpacing = 5
        view.addSubview(collectionView2)
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.allowsMultipleSelection = true
        
        let layout2 = UICollectionViewFlowLayout()
        collectionView1 = UICollectionView(frame: CGRect(x: 0, y: 110, width: self.view.frame.size.width, height: self.view.frame.size.height - 110), collectionViewLayout: layout2)
        collectionView1.register(CollectionView2.self, forCellWithReuseIdentifier: "View2")
        layout2.scrollDirection = .vertical
        layout2.minimumLineSpacing = 5
        layout2.minimumInteritemSpacing = 5
        view.addSubview(collectionView1)
        collectionView1.delegate = self
        collectionView1.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView2 {
            if indexPath.row == 0 {
                if isSelected[indexPath.row] == false {
                    isSelected[0] = true
                    for i in 1...Restaurant.RestaurantType.allCases.count + 1 {
                        isSelected[i] = false
                    }
                    types = [Restaurant.RestaurantType]()
                    filt(restaurantTypes: Restaurant.RestaurantType.allCases)
                }
            } else if isSelected[indexPath.row] == false {
                isSelected[0] = false
                isSelected[indexPath.row] = true
                let cell = collectionView2.cellForItem(at: indexPath) as! CollectionView1
                let restaurantType = Restaurant.RestaurantType(rawValue: cell.label.text!)
                types.append(restaurantType!)
                filt(restaurantTypes: types)
            } else if isSelected[indexPath.row] == true {
                isSelected[indexPath.row] = false
                if isSelected.contains(true) {
                    let cell = collectionView2.cellForItem(at: indexPath) as! CollectionView1
                    let restaurantType = Restaurant.RestaurantType(rawValue: cell.label.text!)
                    types.append(restaurantType!)
                    types = types.filter { $0 != restaurantType }
                    filt(restaurantTypes: types)
                } else {
                    isSelected[0] = true
                    types = [Restaurant.RestaurantType]()
                    filt(restaurantTypes: Restaurant.RestaurantType.allCases)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView2 {
            let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: "View1", for: indexPath) as! CollectionView1
            cell.label.text = Restaurant.RestaurantType.allCases[indexPath.row].rawValue
            cell.label.backgroundColor = .white
            if isSelected[indexPath.row] == true {
                cell.label.textColor = .red
            } else {
                cell.label.textColor = .black
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "View2", for: indexPath) as! CollectionView2
            let restaurant = isSelected[0] != true ? filtered[indexPath.row] : restaurants[indexPath.row]
            cell.nameLabel.text = restaurant.name
            cell.typeLabel.text = restaurant.type.rawValue
            cell.phoneLabel.text = restaurant.phone
            cell.backgroundColor = .white
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          if collectionView == self.collectionView2 {
              return .init(top: 5, left: 5, bottom: 5, right: 5)
          } else {
              return .init(top: 0, left: 5, bottom: 0, right: 5)
          }
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          if collectionView == collectionView2 {
              return CGSize(width: 80, height: 30)
          } else {
              let size = (collectionView.frame.width - 3 * 5) / 2.0
              return CGSize(width: size, height: 70)
          }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView2 {
            return Restaurant.RestaurantType.allCases.count
        } else {
            return isSelected[0] != true ? filtered.count : restaurants.count
        }
    }
    
    private func filt(restaurantTypes: [Restaurant.RestaurantType?]) {
        filtered = restaurants.filter { (restaurant) in
            restaurantTypes.contains(restaurant.type)
        }
        collectionView1.reloadData()
        collectionView2.reloadData()
    }
}

struct Restaurant {
    let name: String
    let type: RestaurantType
    let phone: String = "xxx-xxx-xxxx"
    
    enum RestaurantType : String {
        case all
        case type1
        case type2
        case type3
        case type4
        case type5
        case type6
        case type7
        case type8
        case type9
        case type10
    }
}

extension Restaurant.RestaurantType: CaseIterable { }

class CollectionView1: UICollectionViewCell {
    
    let label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 15)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CollectionView2: UICollectionViewCell {
        
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let typeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let phoneLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(typeLabel)
        
        nameLabel.bottomAnchor.constraint(equalTo: phoneLabel.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        
        phoneLabel.bottomAnchor.constraint(equalTo: typeLabel.topAnchor).isActive = true
        phoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        
        typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
