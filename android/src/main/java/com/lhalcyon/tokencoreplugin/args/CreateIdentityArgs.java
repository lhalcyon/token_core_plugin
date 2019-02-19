package com.lhalcyon.tokencoreplugin.args;

import com.lhalcyon.tokencore.wallet.bip.Words;
import com.lhalcyon.tokencore.wallet.ex.Network;
import com.lhalcyon.tokencore.wallet.ex.SegWit;

public class CreateIdentityArgs implements ArgsValid{

    public String password;

    public String network;

    public String segwit;

    public int words;

    @Override
    public boolean isValid(){
        boolean enumValid = true;

        try {
            Network.valueOf(this.network);
            SegWit.valueOf(segwit);
            Words.valueOf(this.words);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            enumValid = false;
        }
        return null != password && enumValid ;
    }

    public Network getNetwork(){
        return Network.valueOf(network);
    }

    public SegWit getSegwit() {
        return SegWit.valueOf(segwit);
    }

    public com.lhalcyon.tokencore.wallet.bip.Words getWords(){
        return com.lhalcyon.tokencore.wallet.bip.Words.valueOf(words);
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
