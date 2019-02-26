package com.lhalcyon.tokencoreplugin.args;


import com.lhalcyon.tokencore.foundation.utils.MnemonicUtil;
import com.lhalcyon.tokencore.wallet.ex.Network;
import com.lhalcyon.tokencore.wallet.ex.SegWit;

import java.util.Arrays;
import java.util.List;

public class RecoverIdentityArgs implements ArgsValid{

    public String password;

    public String network;

    public String segWit;

    public String mnemonic;

    public com.lhalcyon.tokencore.wallet.ex.Network getNetwork(){
        return com.lhalcyon.tokencore.wallet.ex.Network.valueOf(network);
    }

    public com.lhalcyon.tokencore.wallet.ex.SegWit getSegWit() {
        return com.lhalcyon.tokencore.wallet.ex.SegWit.valueOf(segWit);
    }

    @Override
    public boolean isValid() {
        try {
            String[] split = mnemonic.split(" ");
            List<String> mnemonic = Arrays.asList(split);
            MnemonicUtil.validateMnemonics(mnemonic);
            Network.valueOf(network);
            SegWit.valueOf(segWit);
            return password != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
