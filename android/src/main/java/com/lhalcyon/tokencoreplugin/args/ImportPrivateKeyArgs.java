package com.lhalcyon.tokencoreplugin.args;

import com.lhalcyon.tokencore.wallet.ex.ChainType;
import com.lhalcyon.tokencore.wallet.ex.Network;
import com.lhalcyon.tokencore.wallet.ex.SegWit;
import com.lhalcyon.tokencore.wallet.validators.PrivateKeyValidator;
import com.lhalcyon.tokencore.wallet.validators.WIFValidator;

import org.bitcoinj.params.MainNetParams;
import org.bitcoinj.params.TestNet3Params;

public class ImportPrivateKeyArgs implements ArgsValid {

    public String privateKey;

    public String password;

    public String network;

    public String segwit;

    public String chainType;

    @Override
    public boolean isValid() {
        // check enums
        boolean enumValid = true;
        try {
            Network.valueOf(network);
            SegWit.valueOf(segwit);
            ChainType.valueOf(chainType);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            enumValid = false;
        }
        // check privateKey
        boolean pkValid = true;
        if (ChainType.BITCOIN.getValue().equals(chainType)){
            WIFValidator wifValidator = new WIFValidator(privateKey,Network.TESTNET.getValue().equals(network)? TestNet3Params.get() : MainNetParams.get());
            try {
                wifValidator.validate();
            } catch (Exception e) {
                e.printStackTrace();
                pkValid = false;
            }
        } else {
            // make some point
            PrivateKeyValidator privateKeyValidator = new PrivateKeyValidator(privateKey);
            try {
                privateKeyValidator.validate();
            } catch (Exception e) {
                e.printStackTrace();
                pkValid = false;
            }
        }
        return password != null && enumValid && pkValid;
    }
}
