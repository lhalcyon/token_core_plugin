package com.lhalcyon.tokencoreplugin.args;

public class ExportArgs implements ArgsValid {

    public String keystore;

    public String password;

    @Override
    public boolean isValid() {
        return true;
    }
}
