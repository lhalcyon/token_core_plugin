//
// Created by lhalcyon on 2019-02-23.
//

import Foundation

enum CallMethod: String {

    case createIdentity = "createIdentity"

    case randomMnemonic = "randomMnemonic"

    case recoverIdentity = "recoverIdentity"

    case exportMnemonic = "exportMnemonic"

    case exportPrivateKey = "exportPrivateKey"

    case importPrivateKey = "importPrivateKey"

    case signBitcoinTransaction = "signBitcoinTransaction"

    case signUSDTTransaction = "signUSDTTransaction"

    case verifyPassword = "verifyPassword"
}
