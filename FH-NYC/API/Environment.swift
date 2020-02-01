//
//  Environment.swift
//  FH-NYC
//
//  Created by Christophe Delhaze on 31/1/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import Foundation

public struct Environment {
    
    public enum EnvironmentType {
        case none
        case development
        case production
        
        func toString() -> String {
            switch self {
            case .none:
                return "None"
            case .development:
                return "Development"
            case .production:
                return "Production"
            }
        }
    }
    
    public enum Keys {
        case serverApiURL
        case connectionProtocol
        case configName
        case apiVersion
        
        func value() -> String {
            switch self {
            case .serverApiURL:
                return "server_api_url"
            case .connectionProtocol:
                return "protocol"
            case .configName:
                return "config_name"
            case .apiVersion:
                return "api_version"
            }
        }
    }

    fileprivate var infoDict: [String: Any] {
        get {
            guard let dict = Bundle.main.infoDictionary,
                let appSettings = dict["app_settings"] as? [String: AnyObject] else {
                    fatalError("Environment file not found")
            }
            
            return appSettings
        }
    }

    public func configuration(_ key: Keys) -> String {
        return infoDict[key.value()] as! String
    }
    
    public var environmentType: EnvironmentType {
        let configName = self.configuration(.configName)
        
        if configName == "Dev" {
            return .development
        } else if configName == "Prod" {
            return .production
        }
        
        return .none
    }

}
