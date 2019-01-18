package com.lhalcyon.tokencoreplugin.model;

import com.lhalcyon.tokencore.wallet.ex.ChainType;
import com.lhalcyon.tokencore.wallet.ex.ExMetadata;
import com.lhalcyon.tokencore.wallet.ex.Network;
import com.lhalcyon.tokencore.wallet.ex.SegWit;
import com.lhalcyon.tokencore.wallet.ex.WalletFrom;
import com.lhalcyon.tokencore.wallet.ex.WalletType;

public class FlutterExMetadata {

    public int walletFrom;

    public int network;

    public int segWit;

    public int walletType;

    public String ChainType;

    public FlutterExMetadata(ExMetadata metadata) {
        Network network = metadata.getNetwork();
        ChainType chainType = metadata.getChainType();
        SegWit segWit = metadata.getSegWit();
        WalletType walletType = metadata.getWalletType();
        WalletFrom from = metadata.getFrom();

        this.network = network == null ? this.network : network.getValue();
        this.ChainType = chainType == null ? this.ChainType : chainType.getValue();
        this.segWit = segWit == null ? this.segWit : segWit.getValue();
        this.walletFrom = from == null ? this.walletFrom : from.getValue();
        this.walletType = walletType == null ? this.walletType : walletType.getValue();
    }


}
