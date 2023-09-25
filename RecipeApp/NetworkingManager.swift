//
//  NetworkingManager.swift
//  RecipeApp
//
//  Created by Mira Philip on 2023-08-13.
//

import Foundation
import UIKit

class NetworkingManager {
    
    public static var shared = NetworkingManager()
    
    func getAllRecipes(url : String, completionHandler: @escaping (Result<Data,Error>)->Void){
        
        let headers = [
            "X-RapidAPI-Key": "6c4cc85b23msh605c8f7eb007f08p16f4f1jsn1648716dd0d1",
            "X-RapidAPI-Host": "tasty.p.rapidapi.com"
        ]

        if let urlObject = URL(string: url){
            var request = URLRequest(url: urlObject)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                if error != nil {
                    // notify the listener
                    completionHandler(.failure(error!))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completionHandler(.failure(error!))
                    return
                }
                completionHandler(.success(data!))
            }
            task.resume()
        }
    }
    
    func getRecipeDetail(url : String, id: Int, completionHandler: @escaping (Result<Data,Error>)->Void){
        
        let headers = [
            "X-RapidAPI-Key": "6c4cc85b23msh605c8f7eb007f08p16f4f1jsn1648716dd0d1",
            "X-RapidAPI-Host": "tasty.p.rapidapi.com"
        ]

        if var urlComponents = URLComponents(string: url) {
            urlComponents.queryItems = [URLQueryItem(name: "id", value: "\(id)")]
            if let updatedUrl = urlComponents.url {
            var request = URLRequest(url: updatedUrl)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                if error != nil {
                    // notify the listener
                    completionHandler(.failure(error!))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completionHandler(.failure(error!))
                    return
                }
                completionHandler(.success(data!))
            }
            task.resume()
            }
        }
    }
    
}

