package com.lhalcyon.tokencoreplugin.args;

public class VerifyArgs implements ArgsValid{

    public String keystore;

    public String password;

    @Override
    public boolean isValid() {
        return null != password;
    }
}
