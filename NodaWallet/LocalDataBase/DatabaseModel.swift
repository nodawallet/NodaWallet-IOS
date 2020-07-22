//
//  DatabaseModel.swift
//  NodaWallet
//
//  Created by macOsx on 22/04/20.
//  .
//

import Foundation
import web3swift

func addMnemonicPhraseToDB(mnemonic:String, mnemonicID:Int, ethPublicKey: String, walletID:Int, walletName: String, importedBy: String, address: String, privateKey: String) -> MnemonicPhraseDatas {
    let auth = MnemonicPhraseDatas()
    auth.mnemonicPhraseDatas = mnemonic
    auth.mnemonicID = mnemonicID
    auth.ethPublicKey = ethPublicKey
    auth.walletID = walletID
    auth.walletName = walletName
    auth.importedBy = importedBy
    auth.address = address
    auth.privateKey = privateKey
    return auth
}

func updateCurrencyData(currencyName: String, currencyID: Int, currencyImage: String, enable: Bool, address: String, symbol: String, balance: String, decimal: Int, walletID: Int, marketPrice: String, marketPercentage: String, privateKey: String, importedBy: String, isToken: String, geckoID: String, coinPublicKey: String, type: String) -> CurrencyListDatas {
    let auth = CurrencyListDatas()
    auth.currencyName = currencyName
    auth.currencyID = currencyID
    auth.currencyImage = currencyImage
    auth.enable = enable
    auth.address = address
    auth.symbol = symbol
    auth.balance = balance
    auth.decimal = decimal
    auth.walletID = walletID
    auth.marketPrice = marketPrice
    auth.marketPercent = marketPercentage
    auth.privateKey = privateKey
    auth.importedBy = importedBy
    auth.isToken = isToken
    auth.geckoID = geckoID
    auth.coinPublicKey = coinPublicKey
    auth.type = type
    return auth
}

func updateWithdrawHistory(sendAddress: String, toAddress: String, date: String, sendAmount: String, fee: String, gasPrice: String, nonce: String, currency: String, transactionHash: String) -> WithdrawHistoryDatas {
    let auth = WithdrawHistoryDatas()
    auth.sendAddress = sendAddress
    auth.toAddress = toAddress
    auth.date = date
    auth.sendAmount = sendAmount
    auth.fee = fee
    auth.gasPrice = gasPrice
    auth.nonce = nonce
    auth.currency = currency
    auth.transactionHash = transactionHash
    return auth
}
