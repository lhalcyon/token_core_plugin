package com.lhalcyon.tokencoreplugin.args;


import com.lhalcyon.tokencore.foundation.utils.MnemonicUtil;
import com.lhalcyon.tokencore.wallet.ex.Network;
import com.lhalcyon.tokencore.wallet.ex.SegWit;

import java.util.Arrays;
import java.util.List;

public class RecoverIdentityArgs implements ArgsValid{

    public String password;

    public int network;

    public int segwit;

    public String mnemonic;

    public com.lhalcyon.tokencore.wallet.ex.Network getNetwork(){
        return com.lhalcyon.tokencore.wallet.ex.Network.valueOf(network);
    }

    public com.lhalcyon.tokencore.wallet.ex.SegWit getSegwit() {
        return com.lhalcyon.tokencore.wallet.ex.SegWit.valueOf(segwit);
    }

    @Override
    public boolean isValid() {
        try {
            String[] split = mnemonic.split(" ");
            List<String> mnemonic = Arrays.asList(split);
            MnemonicUtil.validateMnemonics(mnemonic);
            return password != null &&
                    Network.valueOf(network) != null &&
                    SegWit.valueOf(segwit) != null
                    ;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
