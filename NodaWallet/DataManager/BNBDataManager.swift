//
//  BNBDataManager.swift
//  NodaWallet
//
//  Created by macOsx on 03/07/20.
//  .
//

import Foundation
import Alamofire

class BNBDataManager {
    
    //GET BALANCE REQUECT BNB
    class func getBNBBalanceRequest(address: String, completionHandler: @escaping (Bool, [[String: Any]], Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        Alamofire.request(Constants.urlConfig.BNB_ACCOUNT_DETAILS_API + address, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let code = responseVal["code"] as? Int {
                        completionHandler(false, [], response.data ?? Data.init(), response.error)
                        return
                    }
                    if let balanceArr = responseVal["balances"] as? [[String: Any]] {
                        completionHandler(true, balanceArr, response.data ?? Data.init(), response.error)
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, [], response.data ?? Data.init(), error)
            }
        }
    }
    
    //GET-ACCOUNT-AND-SEQUENCE-BNB
    class func getAccountDetailsBNB(address: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        Alamofire.request(Constants.urlConfig.BNB_ACCOUNT_DETAILS_API + address, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let code = responseVal["code"] as? Int {
                        completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), response.error)
                        return
                    }
                    completionHandler(true, "success", response.data ?? Data.init(), response.error)
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    //SEND TRANSACTION
    class func BNBSendTX(body: Data, parameter: [String: Any], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {

        var encoding: ParameterEncoding = URLEncoding.default
        encoding = MyHexEncoding(data: body)
        let header = ["Content-Type": "text/plain"]
        Alamofire.request(Constants.urlConfig.BNB_SEND_TX, method: .post, parameters: nil,encoding: encoding, headers: header).responseJSON {
            response in
            switch response.result {
            case .success:
                 if let responseVal = response.result.value as? [[String: AnyObject]] {
                    if let hash = responseVal[0]["hash"] as? String {
                        completionHandler(true, hash, response.data ?? Data.init(), response.error)
                        return
                    }
                    if let ok = responseVal[0]["ok"] as? Int {
                        print(ok)
                        completionHandler(true, "", response.data ?? Data.init(), response.error)
                        return
                    }
                    completionHandler(false, "", response.data ?? Data.init(), response.error)
                 }
                break
            case .failure(let error):
                completionHandler(false, "", response.data ?? Data.init(), response.error)
            }
        }
    }
    
}

struct MyHexEncoding: ParameterEncoding {
    
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        urlRequest.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data.myHexdata
        return urlRequest
    }

}

extension Data {

    var myHexdata: Data {
        return Data(self.myHexlify.utf8)
    }

    var myHexlify: String {
        let hexDigits = Array("0123456789abcdef".utf16)
        var hexChars = [UTF16.CodeUnit]()
        hexChars.reserveCapacity(count * 2)
        for byte in self {
            let (index1, index2) = Int(byte).quotientAndRemainder(dividingBy: 16)
            hexChars.append(hexDigits[index1])
            hexChars.append(hexDigits[index2])
        }
        return String(utf16CodeUnits: hexChars, count: hexChars.count)
    }

}
