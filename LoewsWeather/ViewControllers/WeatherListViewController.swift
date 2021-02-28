//
//  WeatherListViewController.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import UIKit

class WeatherListViewController: UITableViewController {

	private let searchController = UISearchController(searchResultsController: nil)
	private var selectedForecast: Forecast?

	var forecasts: Forecasts? {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Search"

		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "City Name"


		navigationItem.searchController = searchController
		definesPresentationContext = true
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let detailedForecastVC = segue.destination as? DetailedForecastViewController {
			detailedForecastVC.forecast = selectedForecast
			detailedForecastVC.title = searchController.searchBar.text
		}
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

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedForecast = forecasts?.list[indexPath.row]

		performSegue(withIdentifier: "Detailed", sender: nil)
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
