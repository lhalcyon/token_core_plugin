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
            onRandomMnemonic(call,result:result)
        case CallMethod.createIdentity.rawValue:
            onCreateIdentity(call, result: result)
        case CallMethod.recoverIdentity.rawValue:
            onRecoverIdentity(call, result: result)
        case CallMethod.verifyPassword.rawValue:
            onVerityPassword(call, result: result)
        default:result(FlutterMethodNotImplemented)
        }
    }

    private func onRandomMnemonic(_ call: FlutterMethodCall, result: (Any?) -> Void) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }

        let words = arguments["words"] as! Int

        result("words")

    }

    private func onVerityPassword(_ call: FlutterMethodCall, result: (Any?) -> Void) {

    }

    private func onRecoverIdentity(_ call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }
        do {
            let password = arguments["password"] as! String
            let network = Network(rawValue: arguments["network"] as! String)
            let segWit = SegWit(rawValue: arguments["segwit"] as! String)

        } catch {

        }
    }

    // only accept map param
    private func isArgumentIllegal(_ call: FlutterMethodCall, result: FlutterResult) -> Dictionary<String,Any?>? {
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

    private func onCreateIdentity(_ call: FlutterMethodCall, result: FlutterResult) {
        guard let arguments = isArgumentIllegal(call, result: result) else {
            return
        }
        do {
            let password = arguments["password"] as! String
            let network = Network(rawValue: arguments["network"] as! String)
            let segWit = SegWit(rawValue: arguments["segWit"] as! String)
            let words:Int = arguments["words"] as! Int

            let walletMeta = WalletMeta.init(chain: ChainType.btc,from: WalletFrom.mnemonic, network: network, segwit: segWit!)

            let identityAndMnemonic = try Identity.createIdentity(password: password, metadata: walletMeta,words: Words(rawValue: words)!)
            let mnemonic: String = identityAndMnemonic.0
            let identity: Identity = identityAndMnemonic.1


            let metadata = FlutterMetadata.init(metadata: walletMeta)

            var flutterWallets:[FlutterWallet] = []

            for wallet in identity.wallets.reversed() {
                let keystore = wallet.keystore.dump()
                let walletMeta = FlutterMetadata.init(metadata: wallet.metadata)
                let flutterWallet = FlutterWallet.init(keystore: keystore, address: wallet.address, metadata: walletMeta)
                flutterWallets.append(flutterWallet)
            }
            let flutterIdentity = FlutterIdentity.init(keystore: identity.keystore.dump(), metadata: metadata, wallets: flutterWallets)
            result(flutterIdentity.toJSONString())
        } catch {
            result(FlutterError(code: ErrorCode.error.rawValue, message: "\(error)",details: nil))
        }
    }
}
