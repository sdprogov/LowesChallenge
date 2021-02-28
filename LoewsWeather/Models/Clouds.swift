//
//  Clouds.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

struct Clouds: Codable {
	let coverage: Double

	enum CodingKeys: String, CodingKey {
		case coverage = "all"
	}
}
