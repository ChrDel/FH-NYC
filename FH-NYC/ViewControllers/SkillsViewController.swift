//
//  SkillsViewController.swift
//  FH-NYC
//
//  Created by Christophe Delhaze on 31/1/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit

class SkillsViewController: UIViewController {

    let scrollView = UIScrollView()
    let verticalStackView = UIStackView ()
    let labelOne = UILabel()
    let labelTwo = UILabel()
    
    var topCollectionView: UICollectionView!
    var bottomCollectionView1: UICollectionView!
    var bottomCollectionView2: UICollectionView!

    private var topCardsData = [CardsDataModel]()
    private var bottom1CardsData = [CardsDataModel]()
    private var bottom2CardsData = [CardsDataModel]()

    fileprivate func setupScrollView(parent: UIView) {
        // add the scroll view to parent view
        parent.addSubview(scrollView)
        
        scrollView.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        // set scrollview to view size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true

    }

    fileprivate func setupSectionView(_ title: String, parent: UIStackView) {
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        
        view.addSubview(titleLabel)
        parent.addArrangedSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 20).isActive = true
        view.heightAnchor.constraint(equalToConstant: 28+titleLabel.frame.height+15).isActive = true

        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
    fileprivate func setupTopCollectionView(parent: UIStackView) {
        // Create an instance of UICollectionViewFlowLayout since you cant
        // Initialize UICollectionView without a layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 340, height: 200)

        topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topCollectionView.dataSource = self
        topCollectionView.delegate = self
        topCollectionView.register(TopCollectionCell.self, forCellWithReuseIdentifier: TopCollectionCell.cellId)
        topCollectionView.showsVerticalScrollIndicator = false
        topCollectionView.backgroundColor = UIColor(named: "viewBackgroundColor")
        topCollectionView.tag = 0
        
        parent.addArrangedSubview(topCollectionView)

        topCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topCollectionView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 20).isActive = true
        topCollectionView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        topCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    fileprivate func createBottomCollectionView() -> UICollectionView {
        // Create an instance of UICollectionViewFlowLayout since you cant Initialize UICollectionView without a layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 160, height: 158)
        
        return UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    }
    
    fileprivate func setupBottomCollectionView(_ bottomCollectionView: UICollectionView, parent: UIStackView, tag: Int) {
        bottomCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.register(BottomCollectionCell.self, forCellWithReuseIdentifier: BottomCollectionCell.cellId)
        bottomCollectionView.showsVerticalScrollIndicator = false
        bottomCollectionView.backgroundColor = UIColor(named: "viewBackgroundColor")
        bottomCollectionView.tag = tag
        
        parent.addArrangedSubview(bottomCollectionView)

        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomCollectionView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 20).isActive = true
        bottomCollectionView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        bottomCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    fileprivate func setupVerticalStackView(parent: UIView) {
        //Stack View
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .leading
        verticalStackView.spacing = 0

        parent.addSubview(verticalStackView)

        //Constraints
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true

        verticalStackView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Skills"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        setupScrollView(parent: view)
        setupVerticalStackView(parent: scrollView)
        setupSectionView("Get Smart", parent: verticalStackView)
        setupTopCollectionView(parent: verticalStackView)
        setupSectionView("Get Relief", parent: verticalStackView)
        bottomCollectionView1 = createBottomCollectionView()
        setupBottomCollectionView(bottomCollectionView1, parent: verticalStackView, tag: 1)
        setupSectionView("Get Calm", parent: verticalStackView)
        bottomCollectionView2 = createBottomCollectionView()
        setupBottomCollectionView(bottomCollectionView2, parent: verticalStackView, tag: 2)
        
        CardsAPI.shared.getTopCards(useMockData: true) { [weak self] (_, cards) in
            guard let cards = cards else { return }
            self?.topCardsData.removeAll()
            self?.topCardsData.append(contentsOf: cards)
            self?.topCollectionView.reloadData()
        }

        CardsAPI.shared.getBottomCards(index: "1", useMockData: true) { [weak self] (_, cards) in
            guard let cards = cards else { return }
            self?.bottom1CardsData.removeAll()
            self?.bottom1CardsData.append(contentsOf: cards)
            self?.bottomCollectionView1.reloadData()
        }

        CardsAPI.shared.getBottomCards(index: "2", useMockData: true) { [weak self] (_, cards) in
            guard let cards = cards else { return }
            self?.bottom2CardsData.removeAll()
            self?.bottom2CardsData.append(contentsOf: cards)
            self?.bottomCollectionView2.reloadData()
        }

    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

}

extension SkillsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
            case 0:
                return topCardsData.count
            case 1:
                return bottom1CardsData.count
            case 2:
                return bottom2CardsData.count
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionCell.cellId, for: indexPath) as! TopCollectionCell
                cell.setData(data: topCardsData[indexPath.item])
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionCell.cellId, for: indexPath) as! BottomCollectionCell
                cell.backgroundType = .bottom1
                cell.setData(data: bottom1CardsData[indexPath.item])
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionCell.cellId, for: indexPath) as! BottomCollectionCell
                cell.backgroundType = .bottom2
                if indexPath.item > 0 {
                    bottom2CardsData[indexPath.item].locked = true
                }
                cell.setData(data: bottom2CardsData[indexPath.item])
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    
}

extension SkillsViewController: UICollectionViewDelegateFlowLayout {
    
}
