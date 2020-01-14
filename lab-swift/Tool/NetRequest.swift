//
//  NetRequest.swift
//  lab-swift
//
//  Created by q huang on 2020/1/6.
//  Copyright © 2020 qeeniao35. All rights reserved.
//

import UIKit

import Alamofire
import Moya
import SwiftyJSON



enum LabApi {
    case login(_ name : String, password : String)
    case other
}

//Codable

extension LabApi: TargetType {
    var baseURL: URL { return URL(fileURLWithPath: "www.baidu.com") }
    
    var path: String {
        switch self {
        case .login:
            return "/api/v1/login"
        default:
            return ""
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return Alamofire.HTTPMethod.get
        default:
            return Alamofire.HTTPMethod.post
        }
    }
    
    var task: Task {
        var parameters : [String : Any] = [:]
        switch self {
        case .login(let name, password: let password):
            parameters["name"] = name
            parameters["password"] = password
        default:
            break
        }
        
        return Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data { return "".data(using: .utf8)! }
}

protocol JsonModelHandler {
    // json转model
    init(json : JSON)
}

class NetResponse: NSObject, JsonModelHandler {
    var code : Int!
    var success : Bool!
    var message : String!
    var data : [String:Any]?
    
    required init(json: JSON) {
        code = json["code"].intValue
        message = json["message"].stringValue
        data = json["data"].dictionaryObject ?? nil
        success = json["success"].boolValue
    }
    
    init(errorMessage : String?, code: Int = 500) {
        self.code = code
        message = errorMessage
        success = false
    }
}

protocol LabNetDelegate {
    static var api : MoyaProvider<LabApi> { get }
    
    static func net(_ api : LabApi, _ completion : @escaping lntCompletion)
}

extension LabNetDelegate {
    
    static var api : MoyaProvider<LabApi> {
        let provider = MoyaProvider<LabApi>()

        return provider
    }

    static func net(_ api : LabApi, _ completion : @escaping lntCompletion) {
        self.api.request(api) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(moyaResponse.data)
                let response = NetResponse(json: json)
                completion(response)
            case let .failure(error):
                let response = NetResponse(errorMessage: error.errorDescription, code: error.errorCode)
                completion(response);
                break
            }
        }
    }
}

typealias lnt = LabNet
typealias lntCallback = (_ json : JSON , _ error : MoyaError?) -> Void
typealias lntCompletion = (_ response : NetResponse) -> Void

class LabNet : NSObject, LabNetDelegate {
}
