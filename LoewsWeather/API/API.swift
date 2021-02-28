//
//  API.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

public typealias JSON = [String: Any]
public typealias HTTPHeaders = [String: String]

enum RequestMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

enum Result<Value> {
	case success(Value)
	case failure(Error)
}

class Api {

	init(environment: ApiEnvironment = ApiEnvironment.production) {
		self.environment = environment
	}

	var environment: ApiEnvironment

	fileprivate func sendRequest(_ url: String,
								 method: RequestMethod,
								 headers: HTTPHeaders? = nil,
								 body: JSON? = nil,
								 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		guard let url = URL(string: url) else {
			completionHandler(nil, nil, NSError(domain: "LoewsErrorDomain", code: -1, userInfo: nil))
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = method.rawValue

		if let headers = headers {
			urlRequest.allHTTPHeaderFields = headers
			urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		}

		if let body = body {
			urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
		}

		let session = URLSession(configuration: .default)
		let task = session.dataTask(with: urlRequest) { data, response, error in
			completionHandler(data, response, error)
		}

		task.resume()
	}

	fileprivate func sendRequest<T>(url: String,
									method: RequestMethod,
									headers: HTTPHeaders? = nil,
									body: JSON? = nil,
									completion: @escaping (Result<T>) -> Void,
									decodingWith decode: @escaping (JSONDecoder, Data) throws -> T) {
		return sendRequest(url, method: method, headers: headers, body:body) { data, _, error in
			guard let data = data else {
				return completion(.failure(error ?? NSError(domain: "LoewsErrorDomain", code: -1, userInfo: nil)))
			}
			LoewsLogger.log("Response: \(String(decoding: data, as: UTF8.self))")
			do {
				let decoder = JSONDecoder()
				// asking the custom decoding block to do the work
				try completion(.success(decode(decoder, data)))
			} catch let decodingError {
				completion(.failure(decodingError))
			}
		}
	}

	func sendRequest<T: Decodable>(for: T.Type = T.self,
								   route: ApiRoute,
								   method: RequestMethod,
								   headers: HTTPHeaders? = nil,
								   body: JSON? = nil,
								   completion: @escaping (Result<T>) -> Void) {

		let url = route.url(for: self.environment)
		return sendRequest(url: url,
						   method: method,
						   headers: headers,
						   body:body,
						   completion: completion) { decoder, data in try decoder.decode(T.self, from: data) }
	}

	func sendRequest<T: Decodable>(for: [T].Type = [T].self,
								   route: ApiRoute,
								   method: RequestMethod,
								   headers: HTTPHeaders? = nil,
								   body: JSON? = nil,
								   completion: @escaping (Result<[T]>) -> Void) {

		let url = route.url(for: self.environment)
		return sendRequest(url: url,
						   method: method,
						   headers: headers,
						   body:body,
						   completion: completion) { decoder, data in try decoder.decode([T].self, from: data) }
	}
}

let sharedApi = Api()
