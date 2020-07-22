//
//  DataBaseStructure.swift
//  NodaWallet
//
//  Created by macOsx on 23/03/20.
//  .
//

import Foundation
import RealmSwift
import web3swift

class MnemonicPhraseDatas: Object {
    @objc dynamic var mnemonicPhraseDatas = ""
    @objc dynamic var mnemonicID = 0
    @objc dynamic var ethPublicKey = ""
    @objc dynamic var walletID = 0
    @objc dynamic var walletName = ""
    @objc dynamic var importedBy = ""
    @objc dynamic var address = ""
    @objc dynamic var privateKey = ""
}

class CurrencyListDatas: Object {
    @objc dynamic var currencyName = ""
    @objc dynamic var currencyID = 0
    @objc dynamic var currencyImage = ""
    @objc dynamic var enable = true
    @objc dynamic var address = ""
    @objc dynamic var symbol = ""
    @objc dynamic var balance = ""
    @objc dynamic var decimal = 0
    @objc dynamic var walletID = 0
    @objc dynamic var marketPrice = ""
    @objc dynamic var marketPercent = ""
    @objc dynamic var privateKey = ""
    @objc dynamic var importedBy = ""
    @objc dynamic var isToken = ""
    @objc dynamic var geckoID = ""
    @objc dynamic var coinPublicKey = ""
    @objc dynamic var type = ""
}

class WithdrawHistoryDatas: Object {
    @objc dynamic var sendAddress = ""
    @objc dynamic var toAddress = ""
    @objc dynamic var date = ""
    @objc dynamic var sendAmount = ""
    @objc dynamic var fee = ""
    @objc dynamic var gasPrice = ""
    @objc dynamic var nonce = ""
    @objc dynamic var currency = ""
    @objc dynamic var transactionHash = ""
}
