package com.lhalcyon.tokencoreplugin.model;

import java.util.ArrayList;
import java.util.List;

public class FlutterExIdentity {

    public FlutterExMetadata metadata;

    public List<FlutterExWallet> wallets = new ArrayList<>();

    public String keystore;

    public FlutterExIdentity(String keystore,List<FlutterExWallet> wallets,FlutterExMetadata metadata) {
        this.keystore = keystore;
        this.wallets.addAll(wallets);
        this.metadata = metadata;
    }
}
