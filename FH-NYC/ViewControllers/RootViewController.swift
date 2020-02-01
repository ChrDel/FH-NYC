//
//  RootViewController.swift
//  FH-NYC
//
//  Created by Christophe Delhaze on 31/1/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    fileprivate func setupSkillsButton(parent: UIView) {
        let skillsButton = UIButton()
        
        skillsButton.setTitle("View Skills", for: .normal)
        skillsButton.titleLabel?.textColor = .white
        skillsButton.backgroundColor = .blue
        skillsButton.layer.cornerRadius = 15
        skillsButton.addTarget(self, action: #selector(openSkills), for: .touchUpInside)
        
        
        parent.addSubview(skillsButton)

        skillsButton.translatesAutoresizingMaskIntoConstraints = false
        skillsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        skillsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skillsButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        skillsButton.heightAnchor.constraint(equalToConstant: 75).isActive = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.title = "FH-NYC"
        
        setupSkillsButton(parent: view)
        
    }
    
    @objc func openSkills() {
        navigationController?.pushViewController(SkillsViewController(), animated: true)
    }

}
