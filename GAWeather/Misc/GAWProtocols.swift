//
//  Protocols.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

public protocol ViewModelBased where Self: UIViewController {
    associatedtype ViewModel
    var viewModel : ViewModel? { get set }
    
    func bindViewModel()
}

public protocol CellViewModelBased where Self: UITableViewCell {
    associatedtype ViewModel
    var viewModel : ViewModel? { get set }
}

public typealias WeatherInfo = (weatherImage: UIImage?, city: String, weather: String, temperature: String, humidity: String)
