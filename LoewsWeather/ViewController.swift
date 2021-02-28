//
//  ViewController.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		sharedApi.getWeather(for: "Miami") { result in
			switch result {
			case let .success(forecast):
				print("This is the forecast: \(forecast)")
			case let .failure(error):
				print("This is the error: \(error)")
			}
		}
	}


}

