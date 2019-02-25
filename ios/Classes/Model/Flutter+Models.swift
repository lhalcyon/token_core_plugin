//
// Created by lhalcyon on 2019-02-25.
//

import Foundation
import TokenCore

class FlutterIdentity {

    let keystore: String

    var wallets: [FlutterWallet] = []

    let metadata: FlutterMetadata

    init(keystore: String, metadata: FlutterMetadata, wallets: [FlutterWallet]) {
        self.keystore = keystore
        self.metadata = metadata
        self.wallets += wallets
    }

    func toJSON() -> JSONObject {
        return [
            "keystore": keystore,
            "metadata": metadata.toJSON(),
            "wallets": wallets.map { $0.toJSON() }
        ]
    }

    func toJSONString() -> String {
        let data = try! JSONSerialization.data(withJSONObject: toJSON(), options: [])
        return String(data: data, encoding: .utf8)!
    }
}

class FlutterWallet {

    let keystore: String
    let address: String
    let metadata: FlutterMetadata

    init(keystore: String, address: String, metadata: FlutterMetadata) {
        self.keystore = keystore
        self.address = address
        self.metadata = metadata
    }

    func toJSON() -> JSONObject {
        return [
            "keystore":keystore,
            "address":address,
            "metadata":metadata.toJSON()
        ]
    }
}


class FlutterMetadata {

    var walletFrom: String

    var network: String

    var segWit: String

    var chainType: String

    init(metadata: WalletMeta) {
        self.walletFrom = metadata.walletFrom!.rawValue
        self.segWit = metadata.segWit.rawValue
        self.chainType = metadata.chain!.rawValue
        self.network = metadata.network!.rawValue
    }

    func toJSON() -> JSONObject {
        let json: JSONObject = [
            "from": walletFrom,
            "chainType":chainType,
            "network":network,
            "segWit":segWit
        ]
        return json
    }

}
