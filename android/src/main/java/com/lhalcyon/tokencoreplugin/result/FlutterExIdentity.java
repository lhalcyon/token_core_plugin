package com.lhalcyon.tokencoreplugin.result;

import java.util.ArrayList;
import java.util.List;

public class FlutterExIdentity {

    public List<FlutterExWallet> wallets = new ArrayList<>();

    public String keystore;

    public FlutterExIdentity(String keystore,List<FlutterExWallet> wallets) {
        this.keystore = keystore;
        this.wallets.addAll(wallets);
    }
}
