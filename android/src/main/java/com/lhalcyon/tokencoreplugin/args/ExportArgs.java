package com.lhalcyon.tokencoreplugin.args;

public class ExportArgs implements ArgsValid {

    public String keystore;

    public String password;

    @Override
    public boolean isValid() {
        // not check keystore for now , cuz we can check it while parsing it to Keystore class
        return null != password;
    }
}
