//
//  BTCDataManager.swift
//  NodaWallet
//
//  Created by macOsx on 13/06/20.
//  .
//

import Foundation
import Alamofire
import ANLoader

class BTCDataManager {

    class func getTransactionHash(parameter: [String: Any], completionHandler: @escaping (Bool, [String], [String: Any],  Data?, Error?) -> Swift.Void) -> () {
           
           var param = [String: Any]()
           if parameter.count == 0 {
               param = [:]
           } else {
               param = parameter
           }
        
           let header = ["Content-Type": "application/json"]
           Alamofire.request(Constants.urlConfig.BTC_CREATE_TX_NEW, method: .post, parameters: param,encoding: JSONEncoding.default, headers: header).responseJSON {
                  response in
                  switch response.result {
                  case .success:
                      if let responseVal = response.result.value as? [String: Any] {
                         let tosign = responseVal["tosign"] as? [String]
                         let trans = responseVal["tx"] as? [String: Any]
                         completionHandler(true, tosign!, trans!, response.data ?? Data(), response.error)
                      }
                   break
                  case .failure(let error):
                      completionHandler(false, [], [:], response.data ?? Data(), response.error)
                    break
               }
           }
    }
    
    class func sendTransactionHash(parameter: [String: Any], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
          
          var param = [String: Any]()
          if parameter.count == 0 {
              param = [:]
          } else {
              param = parameter
          }
    
          let header = ["Content-Type": "application/json"]
          Alamofire.request(Constants.urlConfig.BTC_SEND_TX, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON {
              response in
              switch response.result {
              case .success:
                  if let responseVal = response.result.value as? [String: AnyObject] {
                     let trans = responseVal["tx"] as? [String: Any] ?? [:]
                     let hash = trans["hash"] as? String ?? ""
                     completionHandler(true, hash, response.data ?? Data(), response.error)
                  }
                  break
              case .failure(let error):
                  completionHandler(false, "", response.data ?? Data(), response.error)
                  break
               
              }
          }
      }
    
    class func getBtcTxDetails(hash: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        showAppLoader()
        let urlString = Constants.urlConfig.GET_BTC_TX_DETAIL_API + hash
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                var inputResponse = 0.0
                var outputResponse = 0.0
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let data = responseVal["data"] as? [String: AnyObject] {
                        if let inputArr = data["inputs"] as? [[String: Any]] {
                            for inpulValue in inputArr {
                                let value = inpulValue["value"] as? String ?? ""
                                let valueInDouble = Double(value) ?? 0
                                inputResponse += valueInDouble
                            }
                        }
                        if let outputArr = data["outputs"] as? [[String: Any]] {
                            for outputValue in outputArr {
                                let value = outputValue["value"] as? String ?? ""
                                let valueInDouble = Double(value) ?? 0
                                outputResponse += valueInDouble
                            }
                        }
                        let minus = inputResponse - outputResponse
                        let minusVal = String(format: "%.8f", minus)
                        completionHandler(true, minusVal, response.data ?? Data.init(), response.error)
                    }
                } else {
                    completionHandler(false, "0", response.data ?? Data.init(), response.error)
                }
                break
            case .failure(let error):
                completionHandler(false, "0", response.data ?? Data.init(), response.error)
            }
        }
    }
    
    
}
