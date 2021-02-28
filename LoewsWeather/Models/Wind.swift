//
//  Wind.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

struct Wind: Codable {
	let speed: Double
	let direction: Double

	enum CodingKeys: String, CodingKey {
		case speed
		case direction = "deg"
	}
}

extension Wind {
	var windDirection: String {
		// TODO: more sophisticated logic goes here, transform degrees to compass directions
		"\(direction) degrees"
	}
}
