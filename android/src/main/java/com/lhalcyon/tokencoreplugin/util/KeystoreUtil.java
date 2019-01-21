package com.lhalcyon.tokencoreplugin.util;

import org.json.JSONException;
import org.json.JSONObject;

public class KeystoreUtil {


    public static boolean isIdentityKeystore(String keystore) {
        boolean isIdentity = false;
        try {
            JSONObject jsonObject = new JSONObject(keystore);
            Object identifier = jsonObject.opt("identifier");
            isIdentity = identifier != null;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return isIdentity;
    }

    public static boolean isHDMnemonicKeystore(String keystore) {
        boolean isHDMnemonic = false;
        try {
            JSONObject jsonObject = new JSONObject(keystore);
            Object identifier = jsonObject.opt("identifier");
            Object encMnemonic = jsonObject.opt("encMnemonic");
            isHDMnemonic = identifier == null && encMnemonic != null;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return isHDMnemonic;
    }

    public static boolean isV3Keystore(String keystore) {
        boolean isHDMnemonic = false;
        try {
            JSONObject jsonObject = new JSONObject(keystore);
            Object identifier = jsonObject.opt("identifier");
            Object encMnemonic = jsonObject.opt("encMnemonic");
            isHDMnemonic = identifier == null && encMnemonic == null;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return isHDMnemonic;
    }
}
