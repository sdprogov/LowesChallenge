//
//  WeatherListViewModel.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/28/21.
//

import Foundation
import UIKit

protocol WeatherListDelegate: class {
	func selected(forecast: Forecast)
	func showError(error: String)
}

class WeatherListViewModel: NSObject {

	init(weatherView: UITableView) {
		tableView = weatherView

		super.init()

		tableView?.delegate = self
		tableView?.dataSource = self
	}

	private weak var tableView: UITableView?
	weak var delegate: WeatherListDelegate?

	private var forecasts: Forecasts? {
		didSet {
			DispatchQueue.main.async {
				self.tableView?.reloadData()
			}
		}
	}


	func findWeather(for city: String) {
		sharedApi.getWeather(for: city) { [weak self] result in
			switch result {
			case let .success(forecast):
				self?.forecasts = forecast
			case let .failure(error):
				self?.delegate?.showError(error: error.localizedDescription)
			}
		}
	}
}

extension WeatherListViewModel: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let forecasts = forecasts else { return 0 }
		return forecasts.list.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell, let forecast = forecasts?.list[indexPath.row]  else { return UITableViewCell() }


		cell.populate(forecast)

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let forecast = forecasts?.list[indexPath.row] else { return }

		delegate?.selected(forecast: forecast)
	}
}
