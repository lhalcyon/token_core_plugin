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
    case CallMethod.createIdentity.rawValue:
      onCreateIdentity(call,result:result)
    case CallMethod.recoverIdentity.rawValue:
      onRecoverIdentity(call,result:result)
    case CallMethod.verifyPassword.rawValue:
      onVerityPassword(call,result:result)
    default:result(FlutterMethodNotImplemented)
    }
    result("iOS " + UIDevice.current.systemVersion)
  }

  private func onVerityPassword(_ call: FlutterMethodCall, result: (Any?) -> Void) {

  }

  private func onRecoverIdentity(_ call: FlutterMethodCall, result: FlutterResult) {

  }

  private func onCreateIdentity(_ call: FlutterMethodCall, result: FlutterResult) {
      guard let arguments = call.arguments as Dictionary<String,Any?> else {
          result(FlutterError(ErrorCode.argsError,
                  String.init(format: <#T##String##Swift.String#>, arguments: <#T##[CVarArg]##[Swift.CVarArg]#>)
          ))
      }
      Identity.createIdentity(password: <#T##String##Swift.String#>, metadata: <#T##WalletMeta##TokenCore.WalletMeta#>)
  }
}
