//
//  WeatherFetcher.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

extension Api {
	func getWeather(for city: String, completion: @escaping (Result<Forecasts>) -> Void) {
		return self.sendRequest(for: Forecasts.self,
									   route: ApiRoute.getWeather(city: city),
			method: .get,
			completion: completion)
	}
}
