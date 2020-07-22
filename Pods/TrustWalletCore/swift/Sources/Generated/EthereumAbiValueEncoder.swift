// Copyright © 2017-2020 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class EthereumAbiValueEncoder {

    public static func encodeBool(value: Bool) -> Data {
        return TWDataNSData(TWEthereumAbiValueEncoderEncodeBool(value))
    }

    public static func encodeInt32(value: Int32) -> Data {
        return TWDataNSData(TWEthereumAbiValueEncoderEncodeInt32(value))
    }

    public static func encodeUInt32(value: UInt32) -> Data {
        return TWDataNSData(TWEthereumAbiValueEncoderEncodeUInt32(value))
    }

    public static func encodeInt256(value: Data) -> Data {
        let valueData = TWDataCreateWithNSData(value)
        defer {
            TWDataDelete(valueData)
        }
        return TWDataNSData(TWEthereumAbiValueEncoderEncodeInt256(valueData))
    }

    public static func encodeUInt256(value: Data) -> Data {
        let valueData = TWDataCreateWithNSData(value)
        defer {
            TWDataDelete(valueData)
        }
        return TWDataNSData(TWEthereumAbiValueEncoderEncodeUInt256(valueData))
    }

    public static func encodeAddress(value: Data) -> Data {
        let valueData = TWDataCreateWithNSData(value)
        defer {
            TWDataDelete(valueData)
        }
        return TWDataNSData(TWEthereumAbiValueEncoderEncodeAddress(valueData))
    }

    public static func encodeString(value: String) -> Data {
        let valueString = TWStringCreateWithNSString(value)
        defer {
            TWStringDelete(valueString)
        }
        return TWDataNSData(TWEthereumAbiValueEncoderEncodeString(valueString))
    }

    public static func encodeBytes(value: Data) -> Data {
        let valueData = TWDataCreateWithNSData(value)
        defer {
            TWDataDelete(valueData)
        }
        return TWDataNSData(TWEthereumAbiValueEncoderEncodeBytes(valueData))
    }

    public static func encodeBytesDyn(value: Data) -> Data {
        let valueData = TWDataCreateWithNSData(value)
        defer {
            TWDataDelete(valueData)
        }
        return TWDataNSData(TWEthereumAbiValueEncoderEncodeBytesDyn(valueData))
    }

    let rawValue: OpaquePointer

    init(rawValue: OpaquePointer) {
        self.rawValue = rawValue
    }


}
