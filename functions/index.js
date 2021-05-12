const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

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

 exports.create10ETH = functions.https.onCall((data, context) => {
    return client.createTransaction({'currency1' : 'ETH', 'currency2' : 'ETH', 'amount' : 0.025, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                          return {
                            qrcode : result.qrcode_url,
                          }
                  });
  });

 exports.createPartnerETH = functions.https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'ETH', 'currency2' : 'ETH', 'amount' : 0.050, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                      qrcode : result.qrcode_url,
                                    }
                            });
            });


exports.create10TRX = functions.https.onCall((data, context) => {
    return client.createTransaction({'currency1' : 'TRX', 'currency2' : 'TRX', 'amount' : 85, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                          return {
                            qrcode : result.qrcode_url,
                          }
                  });
  });

exports.create20TRX = functions.https.onCall((data, context) => {
      return client.createTransaction({'currency1' : 'TRX', 'currency2' : 'TRX', 'amount' : 155, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                            return {
                              qrcode : result.qrcode_url,
                            }
                    });
    });


    exports.create30TRX = functions.https.onCall((data, context) => {
          return client.createTransaction({'currency1' : 'TRX', 'currency2' : 'TRX', 'amount' : 230, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                return {
                                  qrcode : result.qrcode_url,
                                }
                        });
        });


    exports.createPartnerTRX = functions.https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'TRX', 'currency2' : 'TRX', 'amount' : 1515, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                      qrcode : result.qrcode_url,
                                    }
                            });
            });


exports.create10USDT = functions.https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'USDT.ERC20', 'currency2' : 'USDT.ERC20', 'amount' : 121, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                      qrcode : result.qrcode_url,
                                    }
                            });
            });



exports.create20USDT = functions.https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'USDT.ERC20', 'currency2' : 'USDT.ERC20', 'amount' : 242, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                      qrcode : result.qrcode_url,
                                    }
                            });
            });

exports.create30USDT = functions.https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'USDT.ERC20', 'currency2' : 'USDT.ERC20', 'amount' : 363, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                      qrcode : result.qrcode_url,
                                    }
                            });
            });

exports.createpartnerUSDT = functions.https.onCall((data, context) => {
              return client.createTransaction({'currency1' : 'USDT.ERC20', 'currency2' : 'USDT.ERC20', 'amount' : 2438, 'buyer_email' : 'azerbaev87@gmail.com'},function(err,result){
                                    return {
                                      qrcode : result.qrcode_url,
                                    }
                            });
            });