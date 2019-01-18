package com.lhalcyon.tokencoreplugin;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.lhalcyon.tokencore.foundation.utils.MnemonicUtil;
import com.lhalcyon.tokencore.wallet.bip.Words;
import com.lhalcyon.tokencore.wallet.ex.ChainType;
import com.lhalcyon.tokencore.wallet.ex.ExIdentity;
import com.lhalcyon.tokencore.wallet.ex.ExMetadata;
import com.lhalcyon.tokencore.wallet.ex.ExWallet;
import com.lhalcyon.tokencore.wallet.ex.Network;
import com.lhalcyon.tokencore.wallet.ex.SegWit;
import com.lhalcyon.tokencore.wallet.ex.WalletFrom;
import com.lhalcyon.tokencore.wallet.ex.WalletType;
import com.lhalcyon.tokencore.wallet.keystore.ExIdentityKeystore;
import com.lhalcyon.tokencore.wallet.keystore.ExKeystore;
import com.lhalcyon.tokencore.wallet.keystore.V3Keystore;
import com.lhalcyon.tokencore.wallet.transaction.BitcoinTransaction;
import com.lhalcyon.tokencoreplugin.args.ArgsValid;
import com.lhalcyon.tokencoreplugin.args.CreateIdentityArgs;
import com.lhalcyon.tokencoreplugin.args.ExportArgs;
import com.lhalcyon.tokencoreplugin.args.ImportPrivateKeyArgs;
import com.lhalcyon.tokencoreplugin.args.RecoverIdentityArgs;
import com.lhalcyon.tokencoreplugin.args.SignBTCArgs;
import com.lhalcyon.tokencoreplugin.model.FlutterExIdentity;
import com.lhalcyon.tokencoreplugin.model.FlutterExMetadata;
import com.lhalcyon.tokencoreplugin.model.FlutterExWallet;

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
            case CallMethod.importPrivateKey:
                onImportPrivateKey(call,result);
                break;
            case CallMethod.signBitcoinTransaction:
                onSignBitcoinTransaction(call,result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void onSignBitcoinTransaction(MethodCall call, Result result) {
        if (isArgumentLegal(call,result)){
            return;
        }
        Object arguments = call.arguments;
        String json = gson.toJson(arguments);
        SignBTCArgs args = gson.fromJson(json,SignBTCArgs.class);



        BitcoinTransaction bitcoinTransaction = new BitcoinTransaction(args.toAddress,args.changeIndex,args.amount,args.fee,args.getUTXO(gson));


    }

    private void onImportPrivateKey(MethodCall call, Result result) {
        if (isArgumentLegal(call,result)){
            return;
        }
        Object arguments = call.arguments;
        String json = gson.toJson(arguments);
        ImportPrivateKeyArgs args = gson.fromJson(json,ImportPrivateKeyArgs.class);

        if (isArgumentValid(args, call, result)){
            return;
        }

        ExMetadata exMetadata = new ExMetadata();

        boolean isBtcImport = ChainType.BITCOIN.getValue().equals(args.chainType);
        exMetadata.setFrom(isBtcImport?WalletFrom.WIF:WalletFrom.PRIAVTE_KEY);

        exMetadata.setChainType(ChainType.valueOf(args.chainType));
        exMetadata.setNetwork(Network.valueOf(args.network));
        exMetadata.setSegWit(SegWit.valueOf(args.segwit));
        exMetadata.setWalletType(WalletType.V3);

        V3Keystore keystore = new V3Keystore(exMetadata,args.password,args.privateKey,"");
        ExWallet exWallet = new ExWallet(keystore);

        FlutterExMetadata meta = new FlutterExMetadata(exMetadata);
        FlutterExWallet wallet = new FlutterExWallet(meta,keystore.toJsonString(),exWallet.getAddress());
        String s = gson.toJson(wallet);
        result.success(s);

    }

    private void onExportPrivateKey(MethodCall call, Result result) {
        if (isArgumentLegal(call, result)){
            return;
        }
        Object arguments = call.arguments;
        String json = gson.toJson(arguments);
        ExportArgs args = gson.fromJson(json,ExportArgs.class);

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
        ExportArgs args = gson.fromJson(json,ExportArgs.class);

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
