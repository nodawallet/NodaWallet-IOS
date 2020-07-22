//
//  DataInIt.swift
//  NodaWallet
//
//  Created by macOsx on 19/05/20.
//  .
//

import Foundation

extension Data {
    public init?(btcHex: String) {
        let len = btcHex.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = btcHex.index(btcHex.startIndex, offsetBy: i * 2)
            let k = btcHex.index(j, offsetBy: 2)
            let bytes = btcHex[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }

    public var btcHex: String {
        return reduce("") { $0 + String(format: "%02x", $1) }
    }
    
    static func myFromHex(_ hex: String) -> Data? {
        let string = hex.lowercased().stripHexPrefix()
        let array = Array<UInt8>(hex: string)
        if (array.count == 0) {
            if (hex == "0x" || hex == "") {
                return Data()
            } else {
                return nil
            }
        }
        return Data(array)
    }
}
