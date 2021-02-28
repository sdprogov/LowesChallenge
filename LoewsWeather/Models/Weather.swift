//
//  Weather.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

struct Weather: Codable {
	let briefSummary: String
	let briefDescription: String
	let icon: String

	enum CodingKeys: String, CodingKey {
		case briefSummary = "main"
		case briefDescription = "description"
		case icon
	}
}
