
//  n 22/01/20.
//  .
//

import Foundation
import UIKit
import Alamofire
import ANLoader

public func showAppLoader() {
    ANLoader.showLoading("", disableUI: true)
    ANLoader.activityBackgroundColor = .clear
    ANLoader.activityColor = Constants.AppColors.App_Orange_Color ?? UIColor.white
}

public func jsonArray(data: Data) -> [String: Any] {
    do {
        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
        guard let jsonArray = jsonResponse as? [String: Any] else {
            return [:]
        }
        return jsonArray
    } catch(let error) {
        print(error)
        return [:]
    }
}

class DataManager {
    
    class func postRequest(urlString: String, parameter: [String: AnyObject], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        var param = [String: AnyObject]()
        if parameter.count == 0 {
            param = [:]
        } else {
            param = parameter
        }
        
        var topMostViewControllers: UIViewController? {
            var presentedVC = UIApplication.shared.keyWindow?.rootViewController
            while let controller = presentedVC?.presentedViewController {
                presentedVC = controller
            }
            return presentedVC
        }
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        let header = ["Content-Type": "application/json"]
        showAppLoader()
        Alamofire.request(urlString, method: .post, parameters: param,encoding: URLEncoding.default, headers: header).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Int {
                        let message = responseVal["message"] as? String ?? ""
                        if status == 1 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else if status == 2 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, message, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getTransctionRequest(urlString: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        showAppLoader()
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? String {
                        let message = responseVal["message"] as? String ?? ""
                        if status == "1" {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, message, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getCoinCapRequest(urlString: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        let header = ["Accept": "application/json"]
        showAppLoader()
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    completionHandler(true, "Success", response.data ?? Data.init(), response.error)
                } else {
                    completionHandler(false, "Failure", response.data ?? Data.init(), response.error)
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getETHanderc20Balance(urlString: String, completionHandler: @escaping (Bool, String,[[String: Any]], Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
           
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let responseArrETH = responseVal["ETH"] as? [String: Any] {
                        let balanceOfEth = responseArrETH["balance"] as? Double ?? 0
                        if let tokenArr = responseVal["tokens"] as? [[String: Any]] {
                            completionHandler(true, "\(balanceOfEth)", tokenArr, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(true, "\(balanceOfEth)", [], response.data ?? Data.init(), response.error)
                        }
                    }
                }
            break
            case .failure(let error):
                completionHandler(false, "0", [], response.data ?? Data.init(), error)
            }
        }
    }
    
    class func get24HoursVolumeRequest(urlString: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        let header = ["Accept": "application/json"]
        showAppLoader()
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    completionHandler(true, "Success", response.data ?? Data.init(), response.error)
                } else {
                    completionHandler(false, "Failure", response.data ?? Data.init(), response.error)
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getRequest(urlString: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        let header = ["Content-Type": "application/json"]
        showAppLoader()
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Int {
                        let message = responseVal["message"] as? String ?? ""
                        if status == 1 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else if status == 2 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, message, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getMarketAndVolume(urlString: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        showAppLoader()
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    completionHandler(true, "success", response.data ?? Data.init(), response.error)
                } else {
                    completionHandler(false, "failure", response.data ?? Data.init(), response.error)
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getSocialRequest(completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        Alamofire.request(Constants.urlConfig.GET_SOCIAL_LINK, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Int {
                        let message = responseVal["message"] as? String ?? ""
                        if status == 1 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else if status == 2 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, message, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getFAQRequest(completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        Alamofire.request(Constants.urlConfig.GET_FAQ, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Bool {
                        let message = responseVal["message"] as? String ?? ""
                        if status {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, message, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getCurrencyList(completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        Alamofire.request(Constants.urlConfig.GET_CURRENCY_LIST, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            //ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Int {
                        let result = responseVal["message"] as? String ?? ""
                        if status == 1 {
                            completionHandler(true, result, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, result, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getExchangeRate(urlString: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
           
           if !NetworkUtilities.hasConnectivity() {
               return
           }
           
           showAppLoader()
           Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
               response in
               ANLoader.hide()
               switch response.result {
               case .success:
                   if let responseVal = response.result.value as? [String: AnyObject] {
                       if let price = responseVal["price"] as? Double {
                           completionHandler(true, "\(price)", response.data ?? Data.init(), response.error)
                       } else {
                           completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), response.error)
                       }
                   }
                   break
               case .failure(let error):
                   completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
               }
           }
    }
    
    class func getMarketCap(currency: String, ids: String, completionHandler: @escaping (Bool, [[String: Any]], Data?, Error?) -> Swift.Void) -> () {
        
        let urlString = Constants.urlConfig.GET_MARKET_CAP + "\(currency)&ids=\(ids)&order=market_cap_desc"
        if !NetworkUtilities.hasConnectivity() {
            return
        }
              
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
                  //ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [[String: Any]] {
                    if responseVal.count == 0 {
                      completionHandler(true, [], response.data ?? Data.init(), response.error)
                      return
                    }
                    completionHandler(true, responseVal, response.data ?? Data.init(), response.error)
                    }
                break
            case .failure(let error):
                completionHandler(false, [], response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getNewsData(completionHandler: @escaping (Bool, String, [[String: AnyObject]], Data?, Error?) -> Swift.Void) -> () {
           
           if !NetworkUtilities.hasConnectivity() {
               return
           }
           
           Alamofire.request(Constants.urlConfig.GET_NEWS, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
               response in
               switch response.result {
               case .success:
                   if let responseVal = response.result.value as? [String: AnyObject] {
                       if let status = responseVal["status"] as? Bool {
                         let responseArr = responseVal["message"] as? [[String: AnyObject]]
                         if status {
                             completionHandler(true, "success", responseArr ?? [], response.data ?? Data.init(), response.error)
                         } else {
                              completionHandler(false, Constants.Message.errorMsg, [], response.data ?? Data.init(), response.error)
                         }
                       }
                   }
                   break
               case .failure(let error):
                   completionHandler(false, Constants.Message.errorMsg, [], response.data ?? Data.init(), error)
               }
           }
    }
    
    class func getGraphDetails(currency: String, from: String, to: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
           
           if !NetworkUtilities.hasConnectivity() {
               return
           }
        
           let timeStamplUrl = "\(currency)/market_chart/range?vs_currency=\(userSelectedCurrency)&from=\(from)&to=\(to)"
        
           showAppLoader()
           Alamofire.request(Constants.urlConfig.GET_GRAPH_DETAILS + timeStamplUrl, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
               response in
               ANLoader.hide()
               switch response.result {
               case .success:
                   if let responseVal = response.result.value as? [String: AnyObject] {
                      if let priceArr = responseVal["prices"] as? NSArray {
                        completionHandler(true, "success", response.data ?? Data.init(), response.error)
                      } else {
                        completionHandler(false, "failure", response.data ?? Data.init(), response.error)
                      }
                   }
                   break
               case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
               }
           }
    }
    
    class func saveSendRequest(parameter: [String: AnyObject], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
           
           var param = [String: AnyObject]()
           if parameter.count == 0 {
               param = [:]
           } else {
               param = parameter
           }
        
           if !NetworkUtilities.hasConnectivity() {
               return
           }
           
          // let header = ["Content-Type": "application/x-www-form-urlencoded"]
           showAppLoader()
           Alamofire.request(Constants.urlConfig.SAVE_SEND_HISTORY, method: .post, parameters: param,encoding: URLEncoding.default, headers: nil).responseJSON {
               response in
               ANLoader.hide()
               switch response.result {
               case .success:
                   if let responseVal = response.result.value as? [String: AnyObject] {
                       if let status = responseVal["status"] as? Bool {
                           if status {
                               completionHandler(true, "success", response.data ?? Data.init(), response.error)
                           } else {
                               completionHandler(false, "failure", response.data ?? Data.init(), response.error)
                           }
                       }
                   }
                   break
               case .failure(let error):
                   completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
               }
           }
       }
    
    class func getSendHistory(parameter: [String: AnyObject], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        var param = [String: AnyObject]()
        if parameter.count == 0 {
            param = [:]
        } else {
            param = parameter
        }
     
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
       // let header = ["Content-Type": "application/x-www-form-urlencoded"]
        showAppLoader()
        Alamofire.request(Constants.urlConfig.GET_SEND_HISTORY, method: .post, parameters: param,encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Int {
                        let message = responseVal["message"] as? String ?? ""
                        if status == 1 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else if status == 2 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, message, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getTransactionDetails(urlString: String, completionHandler: @escaping (Bool, String, [[String: AnyObject]], Data?, Error?) -> Swift.Void) -> () {
           
           if !NetworkUtilities.hasConnectivity() {
               return
           }
           
           showAppLoader()
           Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
               response in
               ANLoader.hide()
               switch response.result {
               case .success:
                   if let responseVal = response.result.value as? [String: AnyObject] {
                       if let status = responseVal["status"] as? String {
                         let responseArr = responseVal["result"] as? [[String: AnyObject]]
                         if status == "1" {
                            completionHandler(true, "success", responseArr ?? [], response.data ?? Data.init(), response.error)
                         } else {
                            completionHandler(false, Constants.Message.errorMsg, [], response.data ?? Data.init(), response.error)
                         }
                       }
                   }
                   break
               case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, [], response.data ?? Data.init(), error)
               }
           }
    }
    
    class func saveExchangeRequest(parameter: [String: AnyObject], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        var param = [String: AnyObject]()
        if parameter.count == 0 {
            param = [:]
        } else {
            param = parameter
        }
     
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
       // let header = ["Content-Type": "application/x-www-form-urlencoded"]
        showAppLoader()
        Alamofire.request(Constants.urlConfig.SAVE_EXCHANGE_HISTORY, method: .post, parameters: param,encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Bool {
                        if status {
                            completionHandler(true, "success", response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, "failure", response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getExchangeHistory(parameter: [String: AnyObject], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
           
           var param = [String: AnyObject]()
           if parameter.count == 0 {
               param = [:]
           } else {
               param = parameter
           }
        
           if !NetworkUtilities.hasConnectivity() {
               return
           }
           
          // let header = ["Content-Type": "application/x-www-form-urlencoded"]
           Alamofire.request(Constants.urlConfig.GET_EXCHANGE_HISTORY, method: .post, parameters: param,encoding: URLEncoding.default, headers: nil).responseJSON {
               response in
               switch response.result {
               case .success:
                   if let responseVal = response.result.value as? [String: AnyObject] {
                       if let status = responseVal["status"] as? Int {
                           let message = responseVal["message"] as? String ?? ""
                           if status == 1 {
                               completionHandler(true, message, response.data ?? Data.init(), response.error)
                           } else if status == 2 {
                               completionHandler(true, message, response.data ?? Data.init(), response.error)
                           } else {
                               completionHandler(false, message, response.data ?? Data.init(), response.error)
                           }
                       }
                   }
                   break
               case .failure(let error):
                   completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
               }
           }
       }
    
    class func getAboutAPI(parameter: [String: AnyObject], completionHandler: @escaping (Bool, [[String: AnyObject]], Data?, Error?) -> Swift.Void) -> () {
        
        var param = [String: AnyObject]()
        if parameter.count == 0 {
            param = [:]
        } else {
            param = parameter
        }
     
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
       // let header = ["Content-Type": "application/x-www-form-urlencoded"]
        Alamofire.request(Constants.urlConfig.ABOUT_API, method: .post, parameters: param,encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    let content = responseVal["message"] as? [[String: AnyObject]]
                    if let status = responseVal["status"] as? Bool {
                        if status {
                            completionHandler(true, content ?? [], response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, [], response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, [], response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getTransactionHash(parameter: [String: AnyObject], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
           
           var param = [String: AnyObject]()
           if parameter.count == 0 {
               param = [:]
           } else {
               param = parameter
           }
        
           if !NetworkUtilities.hasConnectivity() {
               return
           }
           
          // let header = ["Content-Type": "application/x-www-form-urlencoded"]
           showAppLoader()
           Alamofire.request("https://api.blockcypher.com/v1/btc/test/txs/new", method: .post, parameters: param,encoding: URLEncoding.default, headers: nil).responseJSON {
               response in
               ANLoader.hide()
               switch response.result {
               case .success:
                   if let responseVal = response.result.value as? [String: AnyObject] {
                       if let status = responseVal["status"] as? Int {
                           let message = responseVal["message"] as? String ?? ""
                           if status == 1 {
                               completionHandler(true, message, response.data ?? Data.init(), response.error)
                           } else if status == 2 {
                               completionHandler(true, message, response.data ?? Data.init(), response.error)
                           } else {
                               completionHandler(false, message, response.data ?? Data.init(), response.error)
                           }
                       }
                   }
                   break
               case .failure(let error):
                   completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
               }
           }
       }
    
    class func getMinimumTransactionValue(parameter: [String: AnyObject], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
     
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        let header = ["Content-Type": "application/json"]
        Alamofire.request(Constants.urlConfig.GET_MINIMUM_TRANSACTION, method: .post, parameters: parameter,encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Int {
                        let message = responseVal["message"] as? String ?? ""
                        if status == 1 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else if status == 2 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, message, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func createExchangeTransaction(parameter: [String: AnyObject], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        let header = ["Content-Type": "application/json"]
        Alamofire.request(Constants.urlConfig.CREATE_EXCHANGE_TRANSACTION, method: .post, parameters: parameter,encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Int {
                        let message = responseVal["message"] as? String ?? ""
                        if status == 1 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else if status == 2 {
                            completionHandler(true, message, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, message, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getApproximateValue(parameter: [String: AnyObject], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
           
           if !NetworkUtilities.hasConnectivity() {
               return
           }
           
           let header = ["Content-Type": "application/json"]
           showAppLoader()
           Alamofire.request(Constants.urlConfig.GET_PPROXIMATE_API, method: .post, parameters: parameter,encoding: JSONEncoding.default, headers: header).responseJSON {
               response in
               ANLoader.hide()
               switch response.result {
               case .success:
                   if let responseVal = response.result.value as? [String: AnyObject] {
                       if let status = responseVal["status"] as? Int {
                           let message = responseVal["message"] as? String ?? ""
                           if status == 1 {
                               completionHandler(true, message, response.data ?? Data.init(), response.error)
                           } else if status == 2 {
                               completionHandler(true, message, response.data ?? Data.init(), response.error)
                           } else {
                               completionHandler(false, message, response.data ?? Data.init(), response.error)
                           }
                       }
                   }
                   break
               case .failure(let error):
                   completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
               }
           }
       }
    
    class func getContractABI(address: String, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        ANLoader.showLoading("", disableUI: true)
        let urlString = Constants.urlConfig.GET_CONTRACT_ABI + address + "&apikey=\(api_Key)"
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? String {
                        let result = responseVal["result"] as? String ?? ""
                        if status == "1" {
                            completionHandler(true, result, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, result, response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getContractDetails(address: String, completionHandler: @escaping (Bool, [[String: Any]], Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        let urlString = Constants.urlConfig.VALID_CONTRACT_ADDRESS_API + address + "&page=1&offset=1&apikey=\(api_Key)"
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? String {
                        let result = responseVal["result"] as? [[String: Any]] ?? []
                        if status == "1" {
                            completionHandler(true, result, response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, [], response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, [], response.data ?? Data.init(), error)
            }
        }
    }
    
    class func sendAddressToBackend(parameter: [String: Any], completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
           
        if !NetworkUtilities.hasConnectivity() {
            return
        }
           
        let header = ["Content-Type": "application/json"]
        showAppLoader()
        Alamofire.request(Constants.urlConfig.CREATE_ADDRESS_API, method: .post, parameters: parameter,encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    if let status = responseVal["status"] as? Int {
                        if status == 1 {
                            completionHandler(true, "success", response.data ?? Data.init(), response.error)
                        } else {
                            completionHandler(false, "failure", response.data ?? Data.init(), response.error)
                        }
                    }
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
    
    class func getAllGeckoIDRequest(completionHandler: @escaping (Bool, [[String: Any]], Data?, Error?) -> Swift.Void) -> () {
        
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        
        ANLoader.showLoading("", disableUI: true)
        let urlString = Constants.urlConfig.GET_ALL_GECKO_ID_API
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            ANLoader.hide()
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [[String: AnyObject]] {
                    completionHandler(true, responseVal, response.data ?? Data.init(), response.error)
                    return
                }
                completionHandler(false, [], response.data ?? Data.init(), response.error)
                break
            case .failure(let error):
                completionHandler(false, [], response.data ?? Data.init(), error)
            }
        }
    }
    
}
