//
//  ValidateAddress.swift
//  NodaWallet
//
//  Created by macOsx on 14/07/20.
//  .
//

import Foundation
import TrustWalletCore

public func validateBinanceAddress(address: String) -> Bool {
    return CoinType.binance.validate(address: address)
}
