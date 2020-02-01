//
//  CardsAPI.swift
//  FH-NYC
//
//  Created by Christophe Delhaze on 31/1/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import Foundation

class CardsAPI: API {
    
    static let shared = CardsAPI()
    
    private struct Endpoints {
        static let top = "/top/"
        static let bottom = "/bottom/"
    }

    override internal var apiBaseUrl: String {
        return "\(super.apiBaseUrl)/cards"
    }
    
    func getTopCards(useMockData:Bool = false, completionHandler: @escaping (_ error: Error?, _ cardsData: [CardsDataModel]?) -> Void) {
        if useMockData {
            completionHandler(nil, CardsDataModel.mockupDataTop())
            return
        }
        
        get(Endpoints.top) { (error, json) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                var cardsData = [CardsDataModel]()
                json?.array?.forEach { json in
                    do {
                        let cardData = try CardsDataModel(data: json.dictionaryObject)
                        cardsData.append(cardData)
                    } catch {
                        print("An error occurred parsing Cards Data: \(error) \(json)")
                    }
                }
                completionHandler(nil, cardsData)
            }

        }

    }

    func getBottomCards(index: String, useMockData:Bool = false, completionHandler: @escaping (_ error: Error?, _ cardsData: [CardsDataModel]?) -> Void) {
        if useMockData {
            completionHandler(nil, index == "2" ? CardsDataModel.mockupDataBottom2() : CardsDataModel.mockupDataBottom1())
            return
        }
        
        let parameters: APIData = ["index": index]
        get(Endpoints.bottom, parameters: parameters) { error, json in
            if let error = error {
                completionHandler(error, nil)
            } else {
                var cardsData = [CardsDataModel]()
                json?.array?.forEach { json in
                    do {
                        let cardData = try CardsDataModel(data: json.dictionaryObject)
                        cardsData.append(cardData)
                    } catch {
                        print("An error occurred parsing Cards Data: \(error) \(json)")
                    }
                }
                completionHandler(nil, cardsData)
            }

        }

    }

}
