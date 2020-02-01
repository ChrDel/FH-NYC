//
//  BottomCollectionCell.swift
//  FH-NYC
//
//  Created by Christophe Delhaze on 31/1/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit

class BottomCollectionCell: UICollectionViewCell {

    enum IconType: String {
        case book
        case headphones
        case lock
    }

    enum BackgroundType: String {
        case bottom1
        case bottom2
        case top
    }

    class var cellId: String { "BottomCollectionCell" }

    let durationLabel = UILabel()
    let titleLabel = UILabel()
    let cellIcon = UIImageView()
    let cellBackgroundImage = UIImageView()
    
    var iconType = IconType.book {
        didSet {
            cellIcon.image = UIImage(systemName: iconType.rawValue, withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        }
    }
    
    var backgroundType = BackgroundType.bottom1 {
        didSet {
            cellBackgroundImage.image = UIImage(named: backgroundType.rawValue)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    
    func setData(data: CardsDataModel) {
        durationLabel.text = data.duration
        titleLabel.text = data.title
        iconType = (data.locked) ? .lock : (data.contentType == "audio") ? .headphones : IconType(rawValue: data.contentType) ?? .book
    }

    internal func setupCellBackgroundImage() {
        cellBackgroundImage.image = UIImage(named: backgroundType.rawValue)
        cellBackgroundImage.clipsToBounds = true
        cellBackgroundImage.contentMode = .scaleAspectFill
        addSubview(cellBackgroundImage)
        cellBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellBackgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellBackgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cellBackgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    fileprivate func setupCellIcon() {
        cellIcon.image = UIImage(systemName: iconType.rawValue, withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        cellIcon.tintColor = .gray
        cellIcon.contentMode = .scaleAspectFit
        addSubview(cellIcon)
        cellIcon.translatesAutoresizingMaskIntoConstraints = false
        cellIcon.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        cellIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
    }
    
    fileprivate func setupDurationLabel() {
        durationLabel.textColor = .gray
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.text = "3 min"
        addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.centerYAnchor.constraint(equalTo: cellIcon.centerYAnchor).isActive = true
        durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14).isActive = true
    }
    
    internal func setupTitleLabel() {
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = "Lorem Ipsum"
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 8).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -28).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setupViews(){

        backgroundColor = .white

        setupCellBackgroundImage()
        setupCellIcon()
        setupDurationLabel()
        setupTitleLabel()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
