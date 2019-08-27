//
//  BPMenuCollectionView.swift
//  CoolFrame
//
//  Created by botu on 2019/8/26.
//  Copyright © 2019 com.snailgames.coolframe. All rights reserved.
//

import UIKit

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth  = UIScreen.main.bounds.size.width

class BPMenuCollectionViewCell: UICollectionViewCell {
    var imgIcon :UIImageView = {
        let imgIcon = UIImageView()
        imgIcon.contentMode = UIView.ContentMode.scaleAspectFit
        return imgIcon
    }()
    var menuName :UILabel = {
        let menuName = UILabel()
        menuName.textAlignment = NSTextAlignment.center
        menuName.font = UIFont.systemFont(ofSize: 12)
        menuName.textColor = UIColor.gray
        return menuName
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self .addSubview(self.menuName)
        self.addSubview(self.imgIcon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        self.imgIcon.frame = CGRect(x: 15, y: 10, width: self.frame.size.width - 30, height: self.frame.size.width - 30)
        self.menuName.frame = CGRect(x: 15, y: self.frame.size.height - 12, width: self.frame.size.width - 30, height: 12)
        
    }
    
}

class BPMenuCollectionView: UIView ,UICollectionViewDataSource,UICollectionViewDelegate{
   
    var itemH = kScreenWidth/5
    
    @objc var selfH = 85*2
    
    @objc  var cellSelect:((BPMenuCollectionView,IndexPath) -> Void )?
    @objc  var itemArray = NSMutableArray() {
        didSet{
            self.collectionView.reloadData()
        }
    }
    lazy  var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemH, height: itemH)
        layout.collectionView?.isPagingEnabled = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.register(BPMenuCollectionViewCell.self, forCellWithReuseIdentifier: "BPMenuCollectionViewCell")
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self .addSubview(self.collectionView)
//        self.collectionView.backgroundColor = UIColor.blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BPMenuCollectionView {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.cellSelect != nil) {
            self.cellSelect!(self,indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "BPMenuCollectionViewCell", for: indexPath) as! BPMenuCollectionViewCell
        cell.backgroundColor = UIColor.red
        cell.menuName.text = "dasdasd"
        return cell
    }
}
