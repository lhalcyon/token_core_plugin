package com.lhalcyon.tokencoreplugin.args;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lhalcyon.tokencore.wallet.transaction.BitcoinTransaction.UTXO;
import com.lhalcyon.tokencoreplugin.util.ConvertUtil;

import java.util.ArrayList;

public class SignBTCArgs implements ArgsValid  {

    public String toAddress;

    public long fee;

    public long amount;

    public String utxo;

    public String keystore;

    public int changeIndex;

    public String password;

    public String usdtHex;


    public ArrayList<UTXO> getUTXO(ObjectMapper mapper) throws Exception{
        JavaType javaType = ConvertUtil.getCollectionType(mapper,ArrayList.class, UTXO.class);
        ArrayList<UTXO> configList =  mapper.readValue(utxo, javaType);
        return configList;
    }

    @Override
    public boolean isValid() {
        //todo check
        return true;
    }
}
