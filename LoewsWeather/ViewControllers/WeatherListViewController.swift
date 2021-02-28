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
	private var viewModel: WeatherListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Search"

		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "City Name"


		navigationItem.searchController = searchController
		definesPresentationContext = true

		viewModel = WeatherListViewModel(weatherView: tableView)
		viewModel?.delegate = self
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let detailedForecastVC = segue.destination as? DetailedForecastViewController {
			detailedForecastVC.forecast = selectedForecast
			detailedForecastVC.title = searchController.searchBar.text
		}
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
		viewModel?.findWeather(for: cityName)
	}
}

extension WeatherListViewController: WeatherListDelegate {
	func selected(forecast: Forecast) {
		selectedForecast = forecast
		performSegue(withIdentifier: "Detailed", sender: nil)
	}

	func showError(error: String) {
		let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}


}
