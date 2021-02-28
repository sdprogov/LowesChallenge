//
//  WeatherCell.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import UIKit

class WeatherCell: UITableViewCell {

	@IBOutlet var weatherImage: UIImageView!
	@IBOutlet var weatherDescription: UILabel!
	@IBOutlet var temperature: UILabel!

	func populate(_ forecast: Forecast) {
		weatherImage.image = forecast.weatherIcon
		temperature.text = "Temp: \(forecast.overview.temperature.getFahrenheitToNearestDegree)"
		if let weather = forecast.weather.first {
			weatherDescription.text = weather.briefDescription
		}
	}

	override func prepareForReuse() {
		weatherImage.image = nil
		temperature.text = nil
		weatherDescription.text = nil
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
