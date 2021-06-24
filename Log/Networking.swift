//
//  Networking.swift
//  Log
//
//  Created by Taras Shukhman on 24/06/2021.
//



import Foundation


class Networking: NSObject {
    
    
    enum Result <T>{
        case Success(T)
        case Error(String)
    }
    lazy var staticJSONurl: String = {return "http://api.androidhive.info/json/movies.json" }()
    
    // MARK: -- Fetch JSON Data
    
    
    func getDataWithStaticJSONurl(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        guard let url = URL(string: staticJSONurl) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Movies to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: AnyObject]] {
                    DispatchQueue.main.async {
                        completion(.Success(json))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
    
    
    func getDataQR(qrUrl: String, completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        guard let url = URL(string: qrUrl) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Movies to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        completion(.Success(json))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
}
