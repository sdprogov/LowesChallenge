//
//  Double+Extensions.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/28/21.
//

import Foundation

extension Double {
	var getFahrenheitToNearestDegree: Int {
		let temp = ((self - 273.15) * 1.8 + 32.0).rounded()
		return Int(temp)
	}
}
