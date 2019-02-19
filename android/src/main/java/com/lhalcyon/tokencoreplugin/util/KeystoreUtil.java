package com.lhalcyon.tokencoreplugin.util;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lhalcyon.tokencore.wallet.ex.ExWallet;
import com.lhalcyon.tokencore.wallet.keystore.ExHDMnemonicKeystore;
import com.lhalcyon.tokencore.wallet.keystore.V3Keystore;

public class KeystoreUtil {


    public static boolean isIdentityKeystore(ObjectMapper mapper,String keystore) {
        boolean isIdentity = false;
        try {
            JsonNode jsonNode = mapper.readTree(keystore);
            JsonNode identityNode = jsonNode.findValue("identifier");
            isIdentity = identityNode != null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isIdentity;
    }

    public static boolean isHDMnemonicKeystore(ObjectMapper mapper,String keystore) {
        boolean isHDMnemonic = false;
        try {
            JsonNode jsonNode = mapper.readTree(keystore);
            JsonNode identifier = jsonNode.findValue("identifier");
            JsonNode encMnemonic = jsonNode.findValue("encMnemonic");
            isHDMnemonic = identifier == null && encMnemonic != null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isHDMnemonic;
    }

    public static boolean isV3Keystore(ObjectMapper mapper, String keystore) {
        boolean isV3 = false;
        try {
            JsonNode jsonNode = mapper.readTree(keystore);
            JsonNode identifier = jsonNode.findValue("identifier");
            JsonNode encMnemonic = jsonNode.findValue("encMnemonic");
            isV3 = identifier == null && encMnemonic == null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isV3;
    }
    
    public static ExWallet importFromKeystore(String keystoreJson) throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();
        if (KeystoreUtil.isIdentityKeystore(objectMapper, keystoreJson)) {
            throw new IllegalArgumentException("do not allow export identity keystore 2 private key");
        }
        ExWallet wallet = null;
        if (KeystoreUtil.isHDMnemonicKeystore(objectMapper, keystoreJson)) {
            ExHDMnemonicKeystore keystore = objectMapper.readValue(keystoreJson, ExHDMnemonicKeystore.class);
            wallet = new ExWallet(keystore);
        }
        if (KeystoreUtil.isV3Keystore(objectMapper, keystoreJson)) {
            V3Keystore keystore = objectMapper.readValue(keystoreJson, V3Keystore.class);
            wallet = new ExWallet(keystore);
        }
        if (wallet == null) {
            throw new IllegalArgumentException("unrecognized keystore content");
        }
        return wallet;
    }
}
