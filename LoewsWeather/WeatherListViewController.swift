//
//  WeatherListViewController.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import UIKit

class WeatherListViewController: UITableViewController {

	private let searchController = UISearchController(searchResultsController: nil)
	private var cityName = ""

	var forecasts: Forecasts? {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Forecast"

		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "City Name"


		navigationItem.searchController = searchController
		definesPresentationContext = true
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let forecasts = forecasts else { return 0 }
		return forecasts.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell, let forecast = forecasts?.list[indexPath.row]  else { return UITableViewCell() }


		cell.populate(forecast)

        // Configure the cell...

        return cell
    }

}

extension WeatherListViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		searchController.searchBar.delegate = self
	}
}

extension WeatherListViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let cityName = searchBar.text, cityName.isEmpty == false else {
			// TODO: return error
			return
		}
		sharedApi.getWeather(for: cityName) { [unowned self] result in
			switch result {
			case let .success(forecast):
				self.forecasts = forecast
				print("This is the forecast: \(forecast)")
			case let .failure(error):
				print("This is the error: \(error)")
			}
		}
	}
}
