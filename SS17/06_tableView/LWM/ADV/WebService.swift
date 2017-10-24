//
//  WebService.swift
//  ADV
//
//  Created by Alex on 14.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

fileprivate struct WebServiceConstants {
    static let BaseURL = "http://lwivs18.gm.fh-koeln.de:9000"
    static let BadStatusCodeError = NSError(domain: "LWM-Networking", code: -1, userInfo: [NSLocalizedDescriptionKey: "Statuscode kaputt"])
    static let InvalidJsonError = NSError(domain: "LWM-Networking", code: -1, userInfo: [NSLocalizedDescriptionKey: "Json kaputt"])
}

enum HTTPMethod: String {
    case POST, GET
}

enum Ressource {
    case session
    case schedule
}

fileprivate extension Ressource {
    var url: URL {
        switch self {
        case .session:
            return URL(string: WebServiceConstants.BaseURL + "/sessions")!
        case .schedule:
            return URL(string: WebServiceConstants.BaseURL + "/api/scheduleEntries")!
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .session: return .POST
        case .schedule: return .GET
        }
    }
    
    var contentType: String {
        switch self {
        case .session: return "application/vnd.fhk.login.V1+json"
        case .schedule: return "application/vnd.fhk.scheduleEntry.V1+json"
        }
    }
    
    var cookie: String? {
        switch self {
        case .session: return nil
        case .schedule: return Storage.cookie
        }
    }
    
    func parseJson<T>(_ json: [Json]) -> [T]? {
        switch self {
        case .session: return nil
        case .schedule: return ScheduleEntry.parseJson(json: json) as? [T]
        }
    }
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias Json = [String: Any]

final class WebService {
    
    private static func request(withRessource ressource: Ressource, body: [String: Any] = [:]) -> URLRequest {
        var request = URLRequest(url: ressource.url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5)
        
        request.httpMethod = ressource.httpMethod.rawValue
        request.addValue(ressource.contentType, forHTTPHeaderField: "Content-Type")
        
        if let cookie = ressource.cookie {
            request.addValue(cookie, forHTTPHeaderField: "Cookie")
        }
        
        if !body.isEmpty {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return request
    }
    
    
    /**
     this function will be executed async. `completion` is called on the main thread
     */
    static func login(username: String, password: String, completion: @escaping (Result<String>) -> Void) {
        let body = ["username": username, "password": password]
        
        let request = self.request(withRessource: Ressource.session, body: body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("oops, something is broken here")
                return
            }
            
            var result: Result<String>
            
            if let httpResponse = response as? HTTPURLResponse {
                let cookie = httpResponse.allHeaderFields["Set-Cookie"] as? String
                result = .success(cookie!)
            } else {
                result = .failure(WebServiceConstants.BadStatusCodeError)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
    
    static func get<T>(ressource: Ressource, completion: @escaping (Result<[T]>) -> Void) {
        let request = self.request(withRessource: ressource)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            var result: Result<[T]>
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let json = (try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? [Json] {
                    result = .success(ressource.parseJson(json) ?? [T]())
                } else {
                    result = .failure(WebServiceConstants.InvalidJsonError)
                }
            } else {
                result = .failure(WebServiceConstants.BadStatusCodeError)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
}

final class CachedWebService {
    
    static func scheduleEntries(completion: @escaping (Result<[ScheduleEntry]>) -> ()) {
        if let scheduleEntries = Storage.scheduleEntries {
            print("from cache")
            completion(Result.success(scheduleEntries))
        }
        
        WebService.get(ressource: Ressource.schedule) { (result: Result<[ScheduleEntry]>) in
            print("from network")
            
            if case let .success(entries) = result {
                Storage.scheduleEntries = entries
            }
            
            completion(result)
        }
    }
}
