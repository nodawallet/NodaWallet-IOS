//
//  KeyStoreJsonController.swift
//  NodaWallet
//
//  Created by macOsx on 24/03/20.
//  .
//

import UIKit
import XLPagerTabStrip

class KeyStoreJsonController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension KeyStoreJsonController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "KeyStore")
    }
}
