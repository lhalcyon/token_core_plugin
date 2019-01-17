package com.lhalcyon.tokencoreplugin;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.lhalcyon.tokencore.foundation.utils.MnemonicUtil;
import com.lhalcyon.tokencore.wallet.bip.Words;
import com.lhalcyon.tokencore.wallet.ex.ExIdentity;
import com.lhalcyon.tokencore.wallet.ex.ExMetadata;
import com.lhalcyon.tokencore.wallet.ex.ExWallet;
import com.lhalcyon.tokencore.wallet.keystore.ExIdentityKeystore;
import com.lhalcyon.tokencore.wallet.keystore.ExKeystore;
import com.lhalcyon.tokencoreplugin.args.ArgsValid;
import com.lhalcyon.tokencoreplugin.args.CreateIdentityArgs;
import com.lhalcyon.tokencoreplugin.args.ExportMnemonicArgs;
import com.lhalcyon.tokencoreplugin.args.RecoverIdentityArgs;
import com.lhalcyon.tokencoreplugin.result.FlutterExIdentity;
import com.lhalcyon.tokencoreplugin.result.FlutterExMetadata;
import com.lhalcyon.tokencoreplugin.result.FlutterExWallet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * TokenCorePlugin
 */
public class TokenCorePlugin implements MethodCallHandler {

    private Gson gson = new Gson();

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "realm.lhalcyon.com/token_core_plugin");
        channel.setMethodCallHandler(new TokenCorePlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call == null || call.method == null) {
            result.error(ErrorCode.CALL_ERROR, "call or call.method is null", call);
            return;
        }
        switch (call.method) {
            case CallMethod.createIdentity:
                onCreateIdentity(call, result);
                break;
            case CallMethod.randomMnemonic:
                onRandomMnemonic(call, result);
                break;
            case CallMethod.recoverIdentity:
                onRecoverIdentity(call,result);
                break;
            case CallMethod.exportMnemonic:
                onExportMnemonic(call,result);
                break;
            case CallMethod.exportPrivateKey:
                onExportPrivateKey(call,result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void onExportPrivateKey(MethodCall call, Result result) {
        if (isArgumentLegal(call, result)){
            return;
        }
        Object arguments = call.arguments;
        String json = gson.toJson(arguments);
        ExportMnemonicArgs args = gson.fromJson(json,ExportMnemonicArgs.class);

        ObjectMapper mapper = new ObjectMapper();
        ExKeystore keystore;
        try {
            keystore = mapper.readValue(args.keystore,ExKeystore.class);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }
        if (keystore == null){
            result.error(ErrorCode.MNEMONIC_ERROR,"not mnemonic wallet type",null);
            return;
        }
        try {
            ExWallet wallet = new ExWallet(keystore);
            String privateKey = wallet.exportPrivateKey(args.password);
            result.success(privateKey);
        } catch (Exception e) {
            e.printStackTrace();
            result.error(ErrorCode.PASSWORD_ERROR,"decrypt mnemonic error.password maybe incorrect",null);
        }
    }

    private void onExportMnemonic(MethodCall call, Result result) {
        if (isArgumentLegal(call, result)){
            return;
        }
        Object arguments = call.arguments;
        String json = gson.toJson(arguments);
        ExportMnemonicArgs args = gson.fromJson(json,ExportMnemonicArgs.class);

        ObjectMapper mapper = new ObjectMapper();
        ExIdentityKeystore keystore = null;
        try {
            keystore = mapper.readValue(args.keystore,ExIdentityKeystore.class);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        if (keystore == null){
            result.error(ErrorCode.MNEMONIC_ERROR,"not mnemonic wallet type",null);
            return;
        }
        try {
            String mnemonic = keystore.decryptMnemonic(args.password);
            result.success(mnemonic);
        } catch (Exception e) {
            e.printStackTrace();
            result.error(ErrorCode.PASSWORD_ERROR,"decrypt mnemonic error.password maybe incorrect",null);
        }
    }


    private void onRecoverIdentity(MethodCall call, Result result) {
        if (isArgumentLegal(call, result)){
            return;
        }
        Object arguments = call.arguments;
        String json = gson.toJson(arguments);
        RecoverIdentityArgs args = gson.fromJson(json,RecoverIdentityArgs.class);
        if (isArgumentValid(args, call, result)){
            return;
        }
        ExIdentity rawIdentity = ExIdentity.recoverIdentity(args.mnemonic,args.password,args.getNetwork(),args.getSegwit());
        handleRawIdentity(result, rawIdentity);
    }

    private void handleRawIdentity(Result result, ExIdentity rawIdentity) {
        String keystore = rawIdentity.getKeystore().toString();
        List<FlutterExWallet> wallets = new ArrayList<>();
        for (int i = 0; i < rawIdentity.getWallets().size(); i++) {
            ExWallet exWallet = rawIdentity.getWallets().get(i);
            ExMetadata exMetadata = exWallet.getMetadata();

            FlutterExMetadata metadata = new FlutterExMetadata(exMetadata);
            FlutterExWallet wallet = new FlutterExWallet(metadata,exWallet.getKeystore().toJsonString(),exWallet.getAddress());
            wallets.add(wallet);
        }

        FlutterExIdentity flutterExIdentity = new FlutterExIdentity(keystore,wallets);
        String s = gson.toJson(flutterExIdentity);
        result.success((s));
    }

    @SuppressWarnings({"unused","unchecked"})
    private void onRandomMnemonic(MethodCall call, Result result) {
        if (isArgumentLegal(call, result)){
            return;
        }
        Map<String,Object> map = (Map<String, Object>) call.arguments;
        int words = (int) map.get("words");
        List<String> strings = MnemonicUtil.randomMnemonicCodes(Words.valueOf(words));
        String mnemonic = MnemonicUtil.mnemonicToString(strings);
        result.success(mnemonic);
    }


    private void onCreateIdentity(MethodCall call, Result result) {
        if (isArgumentLegal(call, result)){
            return;
        }
        Object arguments = call.arguments;
        String json = gson.toJson(arguments);
        CreateIdentityArgs args = gson.fromJson(json, CreateIdentityArgs.class);
        if (isArgumentValid(args, call, result)){
            return;
        }
        ExIdentity rawIdentity = ExIdentity.createIdentity(args.password, args.getNetwork(), args.getSegwit(), args.getWords());
        handleRawIdentity(result, rawIdentity);
    }

    private boolean isArgumentLegal(MethodCall call,Result result){
        if (!(call.arguments instanceof Map)){
            result.error(ErrorCode.ARGS_ERROR, String.format("arguments in %s method type error.need map", call.method), null);
            return true;
        }
        return false;
    }

    private boolean isArgumentValid(ArgsValid args, MethodCall call,Result result){
        if (!args.isValid()){
            result.error(ErrorCode.ARGS_ERROR,String.format("arguments in %s method param error",call.method),null);
            return true;
        }
        return false;
    }

}
