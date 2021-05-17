import { IgApiClient, LiveEntity } from '../src';
import Bluebird = require('bluebird');
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const cors = require('cors')({ origin: true });

admin.initializeApp();
const db = admin.firestore();
const runtimeOpts = {
    timeoutSeconds: 300,
    memory: '512MB'
}

var express = require("express"),
      app = express(),
         coinpayments = require("coinpayments"),
         bodyParser = require("body-parser")

app.use(bodyParser.urlencoded({extended: true}));

var Coinpayments = require('coinpayments');
var client = new Coinpayments({
      key: "bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380",
      secret: "1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB",
});

 exports.create10ETH = functions.region("europe-west3").https.onCall((data, context) => {
    return client.createTransaction({'currency1' : 'ETH', 'currency2' : 'ETH', 'amount' : 0.025, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                          return {
                            address : result.address,
                            tx : result.txn_id,
                          }
                  });
  });

 exports.createPartnerETH = functions.region("europe-west3").https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'ETH', 'currency2' : 'ETH', 'amount' : 0.052, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                     address : result.address,
                                     tx : result.txn_id,
                                    }
                            });
            });


exports.create10TRX = functions.region("europe-west3").https.onCall((data, context) => {
    return client.createTransaction({'currency1' : 'TRX', 'currency2' : 'TRX', 'amount' : 85, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                          return {
                            address : result.address,
                            tx : result.txn_id,
                          }
                  });

  });

exports.create20TRX = functions.region("europe-west3").https.onCall((data, context) => {
      return client.createTransaction({'currency1' : 'TRX', 'currency2' : 'TRX', 'amount' : 155, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                            return {
                              address : result.address,
                              tx : result.txn_id,
                            }
                    });
    });


    exports.create30TRX = functions.region("europe-west3").https.onCall((data, context) => {
          return client.createTransaction({'currency1' : 'TRX', 'currency2' : 'TRX', 'amount' : 230, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                return {
                                  address : result.address,
                                tx : result.txn_id,
                                }
                        });
        });


    exports.createPartnerTRX = functions.region("europe-west3").https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'TRX', 'currency2' : 'TRX', 'amount' : 1515, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                      address : result.address,
                                    tx : result.txn_id,
                                    }
                            });
            });


exports.create10USDT = functions.region("europe-west3").https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'USDT.ERC20', 'currency2' : 'USDT.ERC20', 'amount' : 121, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                      address : result.address,
                                      tx : result.txn_id,
                                    }
                            });
            });



exports.create20USDT = functions.region("europe-west3").https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'USDT.ERC20', 'currency2' : 'USDT.ERC20', 'amount' : 242, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                     address : result.address,
                                     tx : result.txn_id,
                                    }
                            });
            });

exports.create30USDT = functions.region("europe-west3").https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'USDT.ERC20', 'currency2' : 'USDT.ERC20', 'amount' : 363, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                     address : result.address,
                                    tx : result.txn_id,
                                    }
                            });
            });

exports.createpartnerUSDT = functions.region("europe-west3").https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'USDT.ERC20', 'currency2' : 'USDT.ERC20', 'amount' : 2438, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                     address : result.address,
                                     tx : result.txn_id,
                                    }
                            });
            });


exports.getTx = functions.region("europe-west3").https.onCall((data, context) => {
              return client.getTx({'txid' : data.txId},function(err,result){
                                    return {
                                     status : result.status,
                                                                     }
                            });
            });

