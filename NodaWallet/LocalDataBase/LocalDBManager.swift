//
//  LocalDBManager.swift
//  NodaWallet
//
//  Created by macOsx on 23/03/20.
//  .
//

import Foundation
import RealmSwift

class LocalDBManager {
    
    private var database:Realm
    static let  sharedInstance = LocalDBManager()
    
    private init() {
        database = try! Realm()
    }
    
    /*For Main-Wallet storage*/
    func getMnemonicDetailsFromDB() -> Results<MnemonicPhraseDatas> {
        let results: Results<MnemonicPhraseDatas> = database.objects(MnemonicPhraseDatas.self)
        return results
    }
    
    func deleteMainWalletFromDB(object: MnemonicPhraseDatas) {
        try! database.write {
            database.delete(object)
        }
    }
    
    func updateWalletName(object: MnemonicPhraseDatas,mnemonic:String, mnemonicID:Int, ethPublicKey: String, walletID:Int, walletName: String){
        let workouts = database.objects(MnemonicPhraseDatas.self).filter("walletID = %@",walletID)
        
        let realm = try! Realm()
        if let workout = workouts.first {
            try! realm.write {
                workout.walletName = walletName
            }
        }
    }
    
    ////****Local DB for Currency list****/
    func addCurrencyListDataToDB(object: CurrencyListDatas) {
        try! database.write {
            database.add(object, update: .error)
        }
    }
    
    func getCurrencyListDetailsFromDB() -> Results<CurrencyListDatas> {
        let results: Results<CurrencyListDatas> = database.objects(CurrencyListDatas.self)
        return results
    }
    
    func deleteCurrencyListFromDB(object: CurrencyListDatas) {
        try! database.write {
            database.delete(object)
        }
    }
    
    func updateShowAndHideCurrency(object: CurrencyListDatas,currencyName: String, currencyID: Int, currencyImage: String, enable: Bool) {
        let workouts = database.objects(CurrencyListDatas.self).filter("currencyID = %@",currencyID)
        
        let realm = try! Realm()
        if let workout = workouts.first {
            try! realm.write {
                workout.enable = enable
            }
        }
    }
    
    func updateMarketPriceAndBalance(object: CurrencyListDatas, currencyID: Int, marketPrice: String, volumeChangePercent: String, balance: String){
        let workouts = database.objects(CurrencyListDatas.self).filter("currencyID = %@",currencyID)
        
        let realm = try! Realm()
        if let workout = workouts.first {
            try! realm.write {
                workout.marketPrice = marketPrice
                workout.marketPercent = volumeChangePercent
                workout.balance = balance
            }
        }
    }
    
    func updateCurrencyBalance(object: CurrencyListDatas, currencyID: Int, balance: String) {
        let workouts = database.objects(CurrencyListDatas.self).filter("currencyID = %@",currencyID)
        let realm = try! Realm()
        if let workout = workouts.first {
            try! realm.write {
                workout.balance = balance
            }
        }
    }
    
    ///Get Exchange History
    func getWithdrawHistoryFromDB() -> Results<WithdrawHistoryDatas> {
        let results: Results<WithdrawHistoryDatas> = database.objects(WithdrawHistoryDatas.self)
        return results
    }
    
    func deleteWithdrawHistoryFromDB(object: WithdrawHistoryDatas) {
        try! database.write {
            database.delete(object)
        }
    }
    
}
