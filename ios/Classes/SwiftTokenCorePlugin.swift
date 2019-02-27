import Flutter
import UIKit
import TokenCore

public class SwiftTokenCorePlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "realm.lhalcyon.com/token_core_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftTokenCorePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case CallMethod.randomMnemonic.rawValue:
            onRandomMnemonic(call, result: result)
        case CallMethod.createIdentity.rawValue:
            onCreateIdentity(call, result: result)
        case CallMethod.recoverIdentity.rawValue:
            onRecoverIdentity(call, result: result)
        case CallMethod.verifyPassword.rawValue:
            onVerityPassword(call, result: result)
        case CallMethod.exportMnemonic.rawValue:
            onExportMnemonic(call, result: result)
        case CallMethod.importPrivateKey.rawValue:
            onImportPrivateKey(call, result: result)
        case CallMethod.exportPrivateKey.rawValue:
            onExportPrivateKey(call, result: result)
        case CallMethod.signBitcoinTransaction.rawValue:
            onSignBitcoinTransaction(call,result:result)
        case CallMethod.signUSDTTransaction.rawValue:
            onSignUSDTTransaction(call,result:result)
        default:result(FlutterMethodNotImplemented)
        }
    }

    private func onSignUSDTTransaction(_ call: FlutterMethodCall, result: (Any?) -> Void) {
        onSignBitcoinTransaction(call, result: result)
    }

    private func onSignBitcoinTransaction(_ call: FlutterMethodCall, result: (Any?) -> Void) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }

        do {
            let to = arguments["toAddress"] as! String
            let fee = arguments["fee"] as! Int64
            let utxosStr = arguments["utxo"] as! String
            let keystore = arguments["keystore"] as! String
            let changeIndex = arguments["changeIndex"] as! Int
            let amount = arguments["amount"] as! Int64
            let password = arguments["password"] as! String
            let usdtHex = arguments["usdtHex"] as? String

            let mapResult = try mapKeystoreString2Object(json: nil, keystoreString: keystore)

            guard let wallet = mapResult.1 else {
                result(FlutterError.init(code: ErrorCode.illegalOperation.rawValue, message: "not a wallet keystore", details: nil))
                return
            }

            let jsonData:Data = utxosStr.data(using: .utf8)!
            let utxo = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! Array<Dictionary<String,Any>>
            print("\(utxo)")
            let transaction:TransactionSignedResult = try WalletManager.btcSignTransaction(wallet: wallet, to: to, amount: amount, fee: fee, password: password, outputs: utxo, changeIdx: changeIndex,usdtHex: usdtHex)

            let transactionJSONObject = [
                "signedTx": transaction.signedTx,
                "txHash": transaction.txHash,
                "wtxID": transaction.wtxID
            ]

            let data = try! JSONSerialization.data(withJSONObject: transactionJSONObject, options: [])
            let transactionJSONString = String(data: data, encoding: .utf8)
            result(transactionJSONString)
        } catch {
            result(FlutterError(code: ErrorCode.signError.rawValue, message: "\(error)", details: nil))
        }

    }

    private func onExportPrivateKey(_ call: FlutterMethodCall, result: (Any?) -> Void) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }
        do {
            let keystore = arguments["keystore"] as! String
            let password = arguments["password"] as! String
            let mapResult = try mapKeystoreString2Object(json: nil, keystoreString: keystore)

            if let wallet = mapResult.1 {
                let privateKey: String = try wallet.privateKey(password: password, isHDWalletExportWif: true)
                result(privateKey)
            }

            if let _ = mapResult.0 {
                result(FlutterError.init(code: ErrorCode.illegalOperation.rawValue, message: "Identity doesn't support export private key.", details: nil))
            }
        } catch {
            result(FlutterError(code: ErrorCode.exportError.rawValue, message: "\(error)", details: nil))
        }
    }

    private func onImportPrivateKey(_ call: FlutterMethodCall, result: (Any?) -> Void) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }
        do {
            let privateKey = arguments["privateKey"] as! String
            let password = arguments["password"] as! String
            let network = Network(rawValue: arguments["network"] as! String)
            let segWit = SegWit(rawValue: arguments["segWit"] as! String)
            let chainType = ChainType(rawValue: arguments["chainType"] as! String)
            let walletMeta = WalletMeta.init(chain: chainType!, from: chainType! == ChainType.btc ? WalletFrom.wif : WalletFrom.privateKey, network: network!, segwit: segWit!)
            let wallet = try BasicWallet.importFromPrivateKey(privateKey, encryptedBy: password, metadata: walletMeta)

            let flutterMetadata = FlutterMetadata.init(metadata: walletMeta)
            let keystore: String = wallet.keystore.dump()
            let flutterWallet = FlutterWallet.init(keystore: keystore, address: wallet.address, metadata: flutterMetadata)
            flutterWallet.toJSON()
        } catch {

        }
    }

    private func onExportMnemonic(_ call: FlutterMethodCall, result: (Any?) -> Void) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }
        do {
            let keystore = arguments["keystore"] as! String
            let password = arguments["password"] as! String

            let jsonData: Data? = keystore.data(using: .utf8)
            let json = try JSONSerialization.jsonObject(with: jsonData!) as! JSONObject
            guard let _ = json["encMnemonic"] else {
                result(FlutterError(code: ErrorCode.illegalOperation.rawValue, message: "The keystore does not have mnemonic.", details: nil))
                return
            }

            let mapResult = try mapKeystoreString2Object(json: json)
            if let identityKeystore = mapResult.0{
                let mnemonic: String = try identityKeystore.mnemonic(from: password)
                result(mnemonic)
            }

            if let wallet = mapResult.1 {
                let mnemonic: String = try wallet.exportMnemonic(password: password)
                result(mnemonic)
            }

        } catch {
            result(FlutterError(code: ErrorCode.exportError.rawValue, message: "\(error)", details: nil))
        }
    }


    private func onRandomMnemonic(_ call: FlutterMethodCall, result: (Any?) -> Void) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }
        do {
            let words = Words(rawValue: arguments["words"] as! Int)
            let mnemonic = MnemonicUtil.generateMnemonic(words: words!)
            result(mnemonic)
        } catch {
            result(FlutterError(code: ErrorCode.error.rawValue, message: "\(error)", details: nil))
        }
    }

    private func onVerityPassword(_ call: FlutterMethodCall, result: (Any?) -> Void) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }
        do {
            let keystore = arguments["keystore"] as! String
            let password = arguments["password"] as! String

            let mapResult = try mapKeystoreString2Object(json: nil, keystoreString: keystore)
            if let identityKeystore = mapResult.0 {
                let verify: Bool = identityKeystore.verify(password: password)
                result(verify)
                return
            }

            if let wallet = mapResult.1 {
                let verify: Bool = wallet.verifyPassword(password)
                result(verify)
                return
            }
            result(FlutterError(code: ErrorCode.keystoreError.rawValue, message: "Keystore type not match.", details: nil))
        } catch {
            result(FlutterError(code: ErrorCode.keystoreError.rawValue, message: "\(error)", details: nil))    
        }

    }

    private func onRecoverIdentity(_ call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }
        do {
            let password = arguments["password"] as! String
            let network = Network(rawValue: arguments["network"] as! String)
            let segWit = SegWit(rawValue: arguments["segWit"] as! String)
            let mnemonic = arguments["mnemonic"] as! String
            let metadata = WalletMeta(chain: ChainType.btc, from: WalletFrom.mnemonic, network: network, segwit: segWit!)
            let identity = try Identity.recoverIdentity(metadata: metadata, mnemonic: mnemonic, password: password)
            handleRawIdentity(result, rawIdentity: identity, identityMeta: metadata)
        } catch {
            result(FlutterError(code: ErrorCode.error.rawValue, message: "\(error)", details: nil))
        }
    }

    private func handleRawIdentity(_ result: FlutterResult, rawIdentity: Identity, identityMeta: WalletMeta) {
        do {
            let metadata = FlutterMetadata.init(metadata: identityMeta)

            var flutterWallets: [FlutterWallet] = []

            for wallet in rawIdentity.wallets {
                let keystore = wallet.keystore.dump()
                let walletMeta = FlutterMetadata.init(metadata: wallet.metadata)
                let flutterWallet = FlutterWallet.init(keystore: keystore, address: wallet.address, metadata: walletMeta)
                flutterWallets.append(flutterWallet)
            }
            let flutterIdentity = FlutterIdentity.init(keystore: rawIdentity.keystore.dump(), metadata: metadata, wallets: flutterWallets)
            result(flutterIdentity.toJSONString())
        } catch {
            result(FlutterError(code: ErrorCode.error.rawValue, message: "\(error)", details: nil))
        }
    }

    private func onCreateIdentity(_ call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }
        do {
            let password = arguments["password"] as! String
            let network = Network(rawValue: arguments["network"] as! String)
            let segWit = SegWit(rawValue: arguments["segWit"] as! String)
            let words: Int = arguments["words"] as! Int

            let walletMeta = WalletMeta.init(chain: ChainType.btc, from: WalletFrom.mnemonic, network: network, segwit: segWit!)

            let identityAndMnemonic = try Identity.createIdentity(password: password, metadata: walletMeta, words: Words(rawValue: words)!)
            let mnemonic: String = identityAndMnemonic.0
            let identity: Identity = identityAndMnemonic.1
            handleRawIdentity(result, rawIdentity: identity, identityMeta: walletMeta)
        } catch {
            result(FlutterError(code: ErrorCode.error.rawValue, message: "\(error)", details: nil))
        }
    }

    // only accept map param
    private func isArgumentIllegal(_ call: FlutterMethodCall, result: FlutterResult) -> Dictionary<String, Any?>? {
        guard let arguments = call.arguments as? Dictionary<String, Any?> else {
            result(FlutterError(
                    code: ErrorCode.argsError.rawValue,
                    message: String.init(format: "arguments in %s method type error.need map", arguments: [call.method]),
                    details: nil
            ))
            return nil
        }
        return arguments
    }

    func mapKeystoreString2Object(json: JSONObject?,keystoreString:String? = nil) throws -> (IdentityKeystore?, BasicWallet?) {
        var theJson:JSONObject
        if let keystoreStr = keystoreString {
            let jsonData: Data? = keystoreStr.data(using: .utf8)
            let json = try JSONSerialization.jsonObject(with: jsonData!) as! JSONObject
            theJson = json
        } else {
            theJson = json!
        }
        if let _ = theJson["identifier"] {
            let identityKeystore = try IdentityKeystore.init(json: theJson)
            return (identityKeystore, nil)
        } else {
            let wallet = try BasicWallet(json: theJson)
            return (nil, wallet)
        }
    }
}


