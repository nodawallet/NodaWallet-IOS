//
//  WithdrawHistoryDataManager.swift
//  NodaWallet
//
//  Created by macOsx on 25/06/20.
//  .
//

import Foundation
import Alamofire
import ANLoader

class WithdrawHistoryManager {
    
    class func getWithdrawHistory(urlString: String, showLoader:Bool, completionHandler: @escaping (Bool, String, Data?, Error?) -> Swift.Void) -> () {
           
        if !NetworkUtilities.hasConnectivity() {
            return
        }
        if showLoader {
            showAppLoader()
        }
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            if showLoader {
                ANLoader.hide()
            }
            switch response.result {
            case .success:
                if let responseVal = response.result.value as? [String: AnyObject] {
                    completionHandler(true, "success", response.data ?? Data.init(), response.error)
                }
                break
            case .failure(let error):
                completionHandler(false, Constants.Message.errorMsg, response.data ?? Data.init(), error)
            }
        }
    }
   
}
