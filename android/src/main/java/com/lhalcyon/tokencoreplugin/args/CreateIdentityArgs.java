package com.lhalcyon.tokencoreplugin.args;

import com.lhalcyon.tokencoreplugin.enums.IdentityEnums.Network;
import com.lhalcyon.tokencoreplugin.enums.IdentityEnums.SegWit;
import com.lhalcyon.tokencoreplugin.enums.IdentityEnums.Words;

public class CreateIdentityArgs implements ArgsValid{

    public String password;

    public int network;

    public int segwit;

    public int words;

    @Override
    public boolean isValid(){
        return null != password &&
                network == Network.testNet || network == Network.mainNet &&
                segwit == SegWit.none || segwit == SegWit.p2wpkh &&
                words == Words.twelve || words == Words.fifteen || words == Words.eighteen || words == Words.twentyOne || words == Words.twentyFour;
    }

    public com.lhalcyon.tokencore.wallet.ex.Network getNetwork(){
        return com.lhalcyon.tokencore.wallet.ex.Network.valueOf(network);
    }

    public com.lhalcyon.tokencore.wallet.ex.SegWit getSegwit() {
        return com.lhalcyon.tokencore.wallet.ex.SegWit.valueOf(segwit);
    }

    public com.lhalcyon.tokencore.wallet.bip.Words getWords(){
        //todo update dependency then add valueOf() to method
        return com.lhalcyon.tokencore.wallet.bip.Words.TWELVE;
    }

    @Override
    public String toString() {
        return "CreateIdentityArgs{" +
                "password='" + password + '\'' +
                ", network=" + network +
                ", segwit=" + segwit +
                ", words=" + words +
                '}';
    }
}
