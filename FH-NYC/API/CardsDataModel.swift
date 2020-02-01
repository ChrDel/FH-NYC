//
//  CardsDataModel.swift
//  FH-NYC
//
//  Created by Christophe Delhaze on 31/1/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import Foundation

struct CardsDataModel {
    
    struct Keys {
        static let contentType = "contentType"
        static let duration = "duration"
        static let title = "title"
        static let content = "content"
        static let statusType = "averageApproval"
    }
    
    private(set) var contentType: String
    private(set) var duration: String
    private(set) var title: String
    private(set) var content: String?
    private(set) var statusType: String?
    var locked = false
    
    init(data: APIData?) throws {
        guard let data = data else {
            throw APIError.missingData
        }
        
        guard let contentType = data[Keys.contentType] as? String else {
            throw APIError.missingRequiredField(name: Keys.contentType)
        }
        
        guard let duration = data[Keys.duration] as? String else {
            throw APIError.missingRequiredField(name: Keys.duration)
        }
        
        guard let title = data[Keys.title] as? String else {
            throw APIError.missingRequiredField(name: Keys.title)
        }
        
        self.contentType = contentType
        self.duration = duration
        self.title = title

        if let content = data[Keys.content] as? String {
            self.content = content
        }

        if let statusType = data[Keys.statusType] as? String {
            self.statusType = statusType
        }
    }
    
    static func mockupDataTop() -> [CardsDataModel] {
        var mockups = [CardsDataModel]()
        let apiData = [Keys.contentType: "book", Keys.duration: "2 min", Keys.title: "Are your nerves super sensitive?", Keys.content: "Peripheral, sensitization, central sensitization, hyperalgesia, allodynia", Keys.statusType: "unread"]
        let cardData = try! CardsDataModel(data: apiData)
        let apiData2 = [Keys.contentType: "book", Keys.duration: "2 min", Keys.title: "Are your bones super fragile?", Keys.content: "arms, legs, skull, feet, hands", Keys.statusType: "read"]
        let cardData2 = try! CardsDataModel(data: apiData2)
        mockups.append(cardData)
        mockups.append(cardData)
        mockups.append(cardData2)
        return mockups
    }

    static func mockupDataBottom1() -> [CardsDataModel] {
        var mockups = [CardsDataModel]()
        let apiData = [Keys.contentType: "book", Keys.duration: "1 min", Keys.title: "Ice and heat your back"]
        let cardData = try! CardsDataModel(data: apiData)
        let apiData2 = [Keys.contentType: "book", Keys.duration: "1 min", Keys.title: "Use a foaming roller"]
        let cardData2 = try! CardsDataModel(data: apiData2)
        let apiData3 = [Keys.contentType: "book", Keys.duration: "1 min", Keys.title: "Lorem ipsum"]
        let cardData3 = try! CardsDataModel(data: apiData3)
        mockups.append(cardData)
        mockups.append(cardData2)
        mockups.append(cardData3)
        mockups.append(cardData3)
        return mockups
    }
    
    static func mockupDataBottom2() -> [CardsDataModel] {
        var mockups = [CardsDataModel]()
        let apiData = [Keys.contentType: "audio", Keys.duration: "1 min", Keys.title: "Lorem ipsum"]
        let cardData = try! CardsDataModel(data: apiData)
        mockups.append(cardData)
        mockups.append(cardData)
        mockups.append(cardData)
        mockups.append(cardData)
        mockups.append(cardData)
        return mockups
    }

}
