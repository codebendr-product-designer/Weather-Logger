//
//  RestManager.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//


import Foundation

class RestManager {
    
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
    
    var headers = Rest()
    var parameters = Rest()
    var body = Rest()
    var data: Data?
    
    func request(url request: URL, with method: HttpMethod, completion: @escaping (_ result: Results) -> Void) {
        let targetURL = addParameters(to: request)
        let httpBody = getBody()
        guard let request = prepare(with: targetURL, httpBody: httpBody, httpMethod: method) else
        {
            completion(Results(withError: CustomError.failedToCreateRequest))
            return
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            completion(Results(with: data, response: Response(url: response), error: error))
        }.resume()
    }
    
    private func addParameters(to url: URL) -> URL {
        if parameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            var queryItems = [URLQueryItem]()
            for (key, value) in parameters.allValues() {
                let item = URLQueryItem(name: key, value: (value as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                queryItems.append(item)
            }
            urlComponents.queryItems = queryItems
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        return url
    }
    
    private func getBody() -> Data? {
        guard let contentType = headers.value(forKey: "Content-Type") else { return nil }
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: body.allValues(), options: [.prettyPrinted, .sortedKeys])
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = body.allValues().map { "\($0)=\(String(describing: ($1 as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return data
        }
    }
    
    func cookie() -> HTTPCookie? {
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        return xsrfCookie
    }
    
    func json() {
        headers.add(value: "application/json", forKey: "Content-Type")
        headers.add(value: "application/json", forKey: "Accept")
    }
    
    private func prepare(with url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        for (header, value) in headers.allValues() {
            request.setValue(value as? String, forHTTPHeaderField: header)
        }
        request.httpBody = httpBody
        return request
    }
    
    enum CustomError: Error {
        case failedToCreateRequest
    }
    
}

extension RestManager.CustomError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        }
    }
}

