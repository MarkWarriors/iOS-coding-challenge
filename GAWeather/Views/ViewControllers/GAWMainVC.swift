//
//  GAWMainVC.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class GAWMainVC: GAWViewController, ViewModelBased {
    typealias ViewModel = GAWMainViewModel
    var viewModel: GAWMainViewModel? = GAWMainViewModel()

    @IBOutlet weak var cityLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bindViewModel()
    }

    func bindViewModel() {
        viewModel?.onErrorOccurred = ({ (error) in
            self.showAlertFor(error: error)
        })
        viewModel?.viewDidAppear()
    }
    
}
