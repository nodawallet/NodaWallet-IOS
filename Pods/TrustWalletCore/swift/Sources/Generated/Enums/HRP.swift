// Copyright © 2017-2020 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

public enum HRP: UInt32, CaseIterable, CustomStringConvertible  {
    case unknown = 0
    case bandChain = 1
    case binance = 2
    case bitcoin = 3
    case bitcoinCash = 4
    case bitcoinGold = 5
    case cardano = 6
    case cosmos = 7
    case digiByte = 8
    case elrond = 9
    case groestlcoin = 10
    case harmony = 11
    case ioTeX = 12
    case kava = 13
    case litecoin = 14
    case monacoin = 15
    case qtum = 16
    case terra = 17
    case viacoin = 18
    case zilliqa = 19

    public var description: String {
        switch self {
        case .unknown: return ""
        case .bandChain: return "band"
        case .binance: return "bnb"
        case .bitcoin: return "bc"
        case .bitcoinCash: return "bitcoincash"
        case .bitcoinGold: return "btg"
        case .cardano: return "addr"
        case .cosmos: return "cosmos"
        case .digiByte: return "dgb"
        case .elrond: return "erd"
        case .groestlcoin: return "grs"
        case .harmony: return "one"
        case .ioTeX: return "io"
        case .kava: return "kava"
        case .litecoin: return "ltc"
        case .monacoin: return "mona"
        case .qtum: return "qc"
        case .terra: return "terra"
        case .viacoin: return "via"
        case .zilliqa: return "zil"
        }
    }
}
