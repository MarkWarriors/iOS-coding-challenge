//
//  GAWViewController.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class GAWViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func showAlertFor(error: GAWError){
        let alert = UIAlertController.init(title: GAWStrings.error, message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        
        let okBtn = UIAlertAction.init(title: GAWStrings.ok, style: UIAlertAction.Style.default)
        
        alert.addAction(okBtn)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

