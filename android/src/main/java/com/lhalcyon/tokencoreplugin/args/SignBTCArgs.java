package com.lhalcyon.tokencoreplugin.args;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.lhalcyon.tokencore.wallet.transaction.BitcoinTransaction.UTXO;

import java.util.ArrayList;
import java.util.List;

public class SignBTCArgs implements ArgsValid  {

    public String toAddress;

    public long fee;

    public long amount;

    public String utxo;

    public String keystore;

    public int changeIndex;

    public String password;

    public String usdtHex;


    public ArrayList<UTXO> getUTXO(Gson gson){
        return gson.fromJson(utxo, new TypeToken<List<UTXO>>(){}.getType());
    }

    @Override
    public boolean isValid() {
        //todo check
        return true;
    }
}
