package com.lhalcyon.tokencoreplugin.args;

public class ImportPrivateKeyArgs implements ArgsValid {

    public String privateKey;

    public String password;

    public int network;

    public int segwit;

    public String chainType;

    @Override
    public boolean isValid() {
        return true;
    }
}
