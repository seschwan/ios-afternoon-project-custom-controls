//
//  ViewController.swift
//  StarRating
//
//  Created by Corey Sessions on 6/21/19.
//  Copyright © 2019 Corey Sessions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func updateRating(_ ratingControl: CustomControl) {
        let star = ratingControl.value == 1 ? "star" : "stars"
        self.navigationItem.title = "User Rating: \(ratingControl.value) \(star)"
    }
    

}

