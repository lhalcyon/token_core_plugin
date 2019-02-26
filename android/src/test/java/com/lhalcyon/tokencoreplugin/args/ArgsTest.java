package com.lhalcyon.tokencoreplugin.args;

import com.lhalcyon.tokencore.wallet.ex.ChainType;
import com.lhalcyon.tokencore.wallet.ex.Network;
import com.lhalcyon.tokencore.wallet.ex.SegWit;

import junit.framework.Assert;

import org.junit.Test;

/**
 * <pre>
 * Create by  :    L
 * Create Time:    2019/2/19
 * Brief Desc :
 * </pre>
 */
public class ArgsTest {

    @Test
    public void testBitcoinImport(){
        ImportPrivateKeyArgs args = new ImportPrivateKeyArgs();
        args.chainType = ChainType.BITCOIN.getValue();
        args.network = Network.TESTNET.getValue();
        args.password = "qq123456";
        args.segWit = SegWit.NONE.getValue();
        args.privateKey = "cPu5FwyCfpEizTJRJwmRDzaLWQyULqmELbFDQDYgxSvquM2Z9JSd";

        boolean valid = args.isValid();
        Assert.assertEquals(true,valid);
    }

    @Test
    public void testEthereumImport(){
        ImportPrivateKeyArgs args = new ImportPrivateKeyArgs();
        args.chainType = ChainType.ETHEREUM.getValue();
        args.network = Network.TESTNET.getValue();
        args.password = "qq123456";
        args.segWit = SegWit.NONE.getValue();

        args.privateKey = "cf6b11eca111f89568631a5670285fe9f50645979bed8cbafa22548dad64260";
        boolean valid = args.isValid();
        Assert.assertEquals(true,valid);
    }
}
