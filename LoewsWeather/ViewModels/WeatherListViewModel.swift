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

		tableView?.setEmptyMessage("Enter city name to search")

		super.init()

		tableView?.delegate = self
		tableView?.dataSource = self
	}

	private weak var tableView: UITableView?
	weak var delegate: WeatherListDelegate?

	private let spinner = UIActivityIndicatorView()
	private let loadingLabel = UILabel()
	private let loadingView = UIView()

	private var forecasts: Forecasts? {
		didSet {
			DispatchQueue.main.async {
				self.tableView?.reloadData()
			}
		}
	}


	func findWeather(for city: String) {
		setLoadingScreen()
		sharedApi.getWeather(for: city) { [weak self] result in
			DispatchQueue.main.async {
				self?.removeLoadingScreen()
			}
			switch result {
			case let .success(forecast):
				self?.forecasts = forecast
			case let .failure(error):
				self?.forecasts = nil
				DispatchQueue.main.async {
					self?.tableView?.setEmptyMessage("No results found for search: \(city)")
					self?.delegate?.showError(error: error.localizedDescription)
				}
			}
		}
	}

	private func setLoadingScreen() {

		guard let tableView = tableView else { return }

		tableView.restore()

		let width: CGFloat = 120
		let height: CGFloat = 30
		loadingView.frame = CGRect(x: 0, y: 0, width: width, height: height)
		loadingView.center = CGPoint(x: UIScreen.main.bounds.midX,y: UIScreen.main.bounds.midY - 44)

		loadingLabel.textColor = .gray
		loadingLabel.textAlignment = .center
		loadingLabel.text = "Loading..."
		loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

		spinner.style = UIActivityIndicatorView.Style.medium
		spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
		spinner.startAnimating()

		loadingView.addSubview(spinner)
		loadingView.addSubview(loadingLabel)

		tableView.addSubview(loadingView)

	}

	private func removeLoadingScreen() {

		spinner.stopAnimating()
		spinner.isHidden = true
		loadingLabel.isHidden = true

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
