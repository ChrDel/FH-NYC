//
//  TopCollectionCell.swift
//  FH-NYC
//
//  Created by Christophe Delhaze on 31/1/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit

class TopCollectionCell: BottomCollectionCell {

    let contentLabel = UILabel()
    let statusIcon = UIImageView()
    let statusLabel = UILabel()
    
    override class var cellId: String { "TopCollectionCell" }

    override func setData(data: CardsDataModel) {
        super.setData(data: data)
        contentLabel.text = data.content
        if data.statusType == "read" {
            statusLabel.text = "Read"
            statusIcon.tintColor = .green
        } else {
            statusLabel.text = "Not yet read"
            statusIcon.tintColor = .lightGray
        }
        iconType = (data.locked) ? .lock : (data.contentType == "audio") ? .headphones : IconType(rawValue: data.contentType) ?? .book
    }

    override func setupViews() {
        super.setupViews()
        
        setupContentLabel()
        setupStatusIcon()
        setupStatusLabel()
    }
    
    override internal func setupCellBackgroundImage() {
        super.setupCellBackgroundImage()
        backgroundType = .top
    }

    override internal func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20).isActive = true
    }

    fileprivate func setupContentLabel() {
        contentLabel.textColor = .gray
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        contentLabel.text = "Lorem Ipsum"
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -28).isActive = true
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    fileprivate func setupStatusIcon() {
        statusIcon.image = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        statusIcon.tintColor = .lightGray
        statusIcon.contentMode = .scaleAspectFit
        addSubview(statusIcon)
        statusIcon.translatesAutoresizingMaskIntoConstraints = false
        statusIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        statusIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
    }

    fileprivate func setupStatusLabel() {
        statusLabel.textColor = .gray
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.text = "Lorem Ipsum"
        statusLabel.textAlignment = .left
        addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.leftAnchor.constraint(equalTo: statusIcon.rightAnchor, constant: 10).isActive = true
        statusLabel.centerYAnchor.constraint(equalTo: statusIcon.centerYAnchor).isActive = true
    }


}
