//
//  TabBarViewController.swift
//  Calculadora
//
//  Created by Nicholas Forte on 30/08/25.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let expert = ExpertViewController()
        let researchers = ResearchersViewController()
        
        expert.tabBarItem = UITabBarItem(title: "Expert", image: UIImage(systemName: "pencil.line"), tag: 0)
        researchers.tabBarItem = UITabBarItem(title: "Researcher", image: UIImage(systemName: "book.fill"), tag: 1)
        
        let controllers = [expert, researchers]
        self.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
    }
}
