//
//  STKeyboardPhotoCollectionCell.swift
//  Bubu
//
//  Created by Sơn Thái on 9/28/16.
//  Copyright © 2016 LOZI. All rights reserved.
//

import UIKit

enum STKeyboardPhotoCollectionCellType {
  case normal
  case selected
}

class STKeyboardPhotoCollectionCell: UICollectionViewCell {

  override var isSelected: Bool {
    didSet {
      self.showBlur()
    }
  }

  weak var asset: AssetModel? { didSet { self.didSetAsset() } }
  fileprivate let image = UIImageView()
  fileprivate let blur = UIVisualEffectView()
  fileprivate let send = UIButton()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit()
    self.initView()
  }

  func initView() {
  }

  func commonInit() {
    self.clipsToBounds = true
    let size: CGFloat = STKeyboardBase.STKeyboardDefaultHeight - 4
    self.image.frame = CGRect(x: 0, y: 0, width: size, height: size)
    self.image.contentMode = .scaleAspectFill

    self.blur.frame = self.image.frame
    self.blur.alpha = 1

    self.send.frame.size = CGSize(width: 75, height: 45)
    self.send.backgroundColor = UIColor.black.alpha(0.2)
    self.send.center = CGPoint(x: size * 0.5, y: size * 0.5)
    self.send.setTitle("Send", for: .normal)
    self.send.setTitleColor(UIColor.white, for: .normal)
    self.send.alpha = 0
    self.send.addTarget(self, action: #selector(STKeyboardPhotoCollectionCell.sendTUI), for: .touchUpInside)
    self.send.clipsToBounds = true
    self.send.layer.cornerRadius = 5
    self.send.layer.borderWidth = 1
    self.send.layer.borderColor = UIColor.white.cgColor

    self.addSubview(self.image)
    self.addSubview(self.blur)
    self.addSubview(self.send)
  }

  func didSetAsset() {
    if let asset = self.asset {
      self.backgroundColor = UIColor.green

      if let cropImage = asset.cropImage, cropImage.size != CGSize.zero {
        self.image.image = cropImage
      } else {
        if let assetImage = AssetsLibrary.getThumnailImagePH(asset: asset.phAsset) {
          self.image.image = assetImage
          asset.cropImage = assetImage
        }
      }
      self.isSelected = asset.isSelected
    }
  }

  func sendTUI() {
    print("===== DID SELECT IMAGE!")
    print("GET image by add observer with name: `NSNotification.Name(rawValue: \"PhotoKeyboardCollectionCellPickImage\")`")
    self.asset?.isSelected = false
    self.isSelected = false
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PhotoKeyboardCollectionCellPickImage"), object: self.asset)
  }

  fileprivate func showBlur() {
    if self.isSelected {
      UIView.animate(withDuration: Constants.animationDuration) {
        self.blur.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        self.send.alpha = 1
      }
    } else {
      UIView.animate(withDuration: Constants.animationDuration) {
        self.blur.effect = nil
        self.send.alpha = 0
      }
    }
  }
}
