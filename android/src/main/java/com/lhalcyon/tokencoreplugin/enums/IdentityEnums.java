package com.lhalcyon.tokencoreplugin.enums;

public interface IdentityEnums {

    interface Network {

        int mainNet = 0;

        int testNet = 1;
    }

    interface SegWit {
        int none = 0;

        int p2wpkh = 1;
    }

    interface ChainType {

        String bitcoin = "BITCOIN";

        String ethereum = "ETHEREUM";

        String eos = "EOS";
    }

    interface WalletFrom {

        int mnemonic = 0;

        int keystore = 1;

        int privateKey = 2;

        int wif = 3;
    }

    interface WalletType {

        int hd = 0;

        int random = 1;

        int v3 = 2;
    }

    interface Words {

        int twelve = 128;

        int fifteen = 160;

        int eighteen = 192;

        int twentyOne = 224;

        int twentyFour = 256;

    }
}
