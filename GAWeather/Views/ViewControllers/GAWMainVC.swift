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
    var viewModel: GAWMainViewModel? = GAWMainViewModel(apiHandler: ApiHandler.init(environment: Environments.testEnv),
                                                        speechRecognizer: GAWSpeechRecognizer())

    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var transcriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.accessibilityIdentifier = "mainView"
        self.weatherView.accessibilityIdentifier = "weatherView"
        self.loadingIndicator.accessibilityIdentifier = "loadingIndicator"
        self.transcriptionLbl.accessibilityIdentifier = "transcriptionLbl"
        self.weatherView.alpha = 0
        self.bindViewModel()
    }

    func bindViewModel() {
        viewModel?.onErrorOccurred = { error in
            self.showAlertFor(error: error)
        }
        
        viewModel?.onLoading = { loading in
            DispatchQueue.main.async {
                if loading {
                    self.loadingIndicator.startAnimating()
                }
                else {
                    self.loadingIndicator.stopAnimating()
                }
            }
        }
        
        viewModel?.onTranscriptionChange = { text in
            DispatchQueue.main.async {
                self.transcriptionLbl.text = text
            }
        }
        
        viewModel?.onWeatherChange = { info in
            DispatchQueue.main.async {
                if let info = info {
                    self.weatherImageView.image = info.weatherImage
                    self.cityLbl.text = info.city
                    self.weatherLbl.text = info.weather
                    self.temperatureLbl.text = info.temperature
                    self.humidityLbl.text = info.humidity
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.weatherView.alpha = (info != nil ? 1.0 : 0.0)
                })
            }
        }
        
        viewModel?.viewDidAppear()
    }
    
}
