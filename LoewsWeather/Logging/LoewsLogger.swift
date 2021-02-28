//
//  LoewsLogger.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

class LoewsLogger {

	public class func log(_ object: Any...) {
		#if DEBUG
		for item in object {
			Swift.print(item)
		}
		#endif
	}

	public class func log(_ object: Any) {
		#if DEBUG
		Swift.print(object)
		#endif
	}
}
