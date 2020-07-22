//
//  Constants.swift

//  .
//

import Foundation
import UIKit
import web3swift
import BitcoinKit

let myAppName = "NodaWallet"

struct Constants {
    
    struct storyBoard {
        static let Main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    }
    
    struct urlConfig {
        //Development
        //YOUR BASE URL
        static let BASE_URL = "https://"
                
        static let GET_GRAPH_DETAILS = "https://api.coingecko.com/api/v3/coins/"
        static let GET_SOCIAL_LINK = BASE_URL + "api/social"
        static let GET_FAQ = BASE_URL + "api/getFaq"
        static let GET_CURRENCY_LIST = BASE_URL + "apiv2/get_currency"
        static let GET_MARKET_CAP = "https://api.coingecko.com/api/v3/coins/markets?vs_currency="
        static let GET_NEWS = BASE_URL + "api/getNews"
        static let SAVE_SEND_HISTORY = BASE_URL + ""
        static let GET_SEND_HISTORY = BASE_URL + ""
        static let SAVE_EXCHANGE_HISTORY = BASE_URL + ""
        static let GET_EXCHANGE_HISTORY = BASE_URL + ""
        static let ABOUT_API = BASE_URL + "api/get_static_page"
        static let CREATE_ADDRESS_API = BASE_URL + ""
        
        //GET CURRENCY BALANCE API
        static let GET_ETH_ERC20_BALANCE_API = "http://api.ethplorer.io/getAddressInfo/"
        static let GET_BTC_BALANCE_API = "https://api.blockcypher.com/v1/btc/"
        static let GET_LTC_BALANCE_API = "https://api.blockcypher.com/v1/ltc/"
        
        //SEND AND RECEIVE HISTORY API
        static let GET_ETH_HISTORY_API = "https://api.etherscan.io/api?"
        static let GET_BTC_HISTORY_API = "https://sochain.com/api/v2/address/BTC/"
        static let GET_LTC_HISTORY_API = "https://sochain.com/api/v2/address/LTC/"
        static let GET_ERC20_HISTORY_API = "https://api.etherscan.io/api?"
        
        //Changelly API - EXCHANGE
        static let GET_MINIMUM_TRANSACTION = BASE_URL + ""
        static let CREATE_EXCHANGE_TRANSACTION = BASE_URL + ""
        static let GET_PPROXIMATE_API = BASE_URL + ""
        
        //BLOCKCYPHER - BTC - SEND
        static let BTC_CREATE_TX_NEW = "https://api.blockcypher.com/v1/btc/main/txs/new"
        static let BTC_SEND_TX = "https://api.blockcypher.com/v1/btc/main/txs/send?token=550e490c15a349aaa9c42cabb48f33b0"
        
        //BLOCKCYPHER - LTC - SEND
        static let LTC_CREATE_TX_NEW = "https://api.blockcypher.com/v1/ltc/main/txs/new"
        static let LTC_SEND_TX = "https://api.blockcypher.com/v1/ltc/main/txs/send?token=550e490c15a349aaa9c42cabb48f33b0"
        
        //DEX.BINANCE - BNB - API
        static let BNB_ACCOUNT_DETAILS_API = "https://dex.binance.org/api/v1/account/"
        static let GET_BNB_HISTORY_API = "https://dex.binance.org/api/v1/transactions?address="
        static let BNB_SEND_TX = "https://dex.binance.org/api/v1/broadcast/?sync=1"
        
        //EXPLORER - API
        static let ETH_EXPLORER_API = "https://etherscan.io/tx/"
        static let BNB_EXPLORER_API = "https://explorer.binance.org/tx/"
        static let BTC_EXPLORER_API = "https://www.blockchain.com/btc/tx/"
        static let LTC_EXPLORER_API = "https://live.blockcypher.com/ltc/tx/"
        
        //GET-CONTRACT-ABI
        static let GET_CONTRACT_ABI = "https://api.etherscan.io/api?module=contract&action=getabi&address="
        static let VALID_CONTRACT_ADDRESS_API = "https://api.etherscan.io/api?module=account&action=tokentx&contractaddress="
        
        //BTC - TX - DETAILS
        static let GET_BTC_TX_DETAIL_API = "https://sochain.com/api/v2/get_tx/BTC/"
        static let GET_LTC_TX_DETAIL_API = "https://sochain.com/api/v2/get_tx/LTC/"
        
        //COINGECKO - FOR - CUSTOM TOKEN
        static let GET_ALL_GECKO_ID_API = "https://api.coingecko.com/api/v3/coins/list"
    }
    
    struct AppColors {
        static let App_Orange_Color = UIColor.init(hexString: "F69F36")
        static let Text_Green_Color = UIColor.init(hexString: "82C777")
        static let Text_Red_Color = UIColor.init(hexString: "FF3B30")
    }
    
    struct UserDefaultKey {
        static let UserID = "UserID"
        static let isDarkModeSelected = "isDarkModeSelected"
        static let isFirstTime = "isFirstTime"
        static let AppLanguage = "AppLanguage"
        static let touchID = "touchID"
        //static let isNotificationEnable = "isNotificationEnable"
        static let passcodeLogin = "passcodeLogin"
        static let mnemonicID = "mnemonicID"
        static let walletID = "walletID"
        static let selectedWalletID = "selectedWalletID"
        static let userSelectedCurrencyID = "userSelectedCurrencyID"
        static let userSelectedCurrencySymbolID = "userSelectedCurrencySymbolID"
        static let updateAddressToBackEnd = "updateAddressToBackEnd"
    }
    
    struct User {
        static var UserID = ""
        static var isDarkMode = false
        static var isFirstTime = true
        static var isTouchID = false
        //static var isNotificationEnable = false
        static var accessCamera = false
    }
    
    struct NavigationColor {
        static let lightMode = "#F69F36"
        static let darkMode = "#232325"
    }
    
    struct BackgroundColor {
        static let lightMode = "#F69F36"
        static let darkMode = "#232325"
    }
    
    struct Message {
        static let errorMsg = "Something went wrong. Please try again later."
        static let kycMessage = "Please upload your KYC Documents to continue.."
        static let kycPendingStatus = "Please wait your KYC is under verification"
    }
    
    struct staticView {
        static var tokenSlideView = UIView()
        static var collectionSlideView = UIView()
    }
    
}

struct SelectedWalletDetails {
    static var walletAddress = ""
    static var balance = ""
    static var mnemonicData = ""
    static var walletID = 0
    static var privateKey = ""
    static var importedBy = ""
}

let transiton = SlideInTransition()
let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
var tabbarSelectedIndex = 1

var currentMarketPrice = "0"
var ETHVolumeChangePercent = "0"

//Production
//ETH
let web3Main = Web3.InfuraMainnetWeb3()
let ropsten = ""
let api_Key = ""//Your Api Key
let balance_Ropsten_API = ""
//BTC
let btcNetwork = Network.mainnetBTC
let btc_Balance = "main"

var firebaseToken = ""

var userSelectedCurrency = ""
var userSelectedCurrencySymbol = ""
