const axios = require('axios');
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
         bodyParser = require("body-parser")

app.use(bodyParser.urlencoded({extended: true}));

const partner = {
  name : "GiveApp Partnership",
          description : "Give App token",
          local_price : {
             amount : "200.00",
             currency : "USD"
          },
          pricing_type : "fixed_price",
           redirect_url : "https://giveapp.ru",
           cancel_url : "https://giveapp.ru"

}

const create10 = {
    name : "Give App Coin",
          description : "Give App token",
          local_price : {
             amount : "10.00",
             currency : "USD"
          },
          pricing_type : "fixed_price",
           redirect_url : "https://giveapp.ru",
           cancel_url : "https://giveapp.ru"

};

const create20 = {
  name : "2000 GiveApp Coin",
          description : "Give App token",
          local_price : {
             amount : "20.00",
             currency : "USD"
          },
          pricing_type : "fixed_price",
           redirect_url : "https://giveapp.ru",
           cancel_url : "https://giveapp.ru"

}

const create30 = {
  name : "3000 Give App Coin",
          description : "Give App token",
          local_price : {
             amount : "30.00",
             currency : "USD"
          },
          pricing_type : "fixed_price",
           redirect_url : "https://giveapp.ru",
           cancel_url : "https://giveapp.ru"

}

exports.create10dollars = functions.region("europe-west3").https.onCall( async (stuff, context) => {
return await axios.post('https://api.commerce.coinbase.com/charges', create10, {
             headers: { "Content-Type": "application/json", "X-CC-Api-Key": "**************", "X-CC-Version": "2018-03-22"},
             })
                                              .then((res) => {
                                                return {
                                                                                 url: res.data.data.hosted_url,
                                                                                 id: res.data.data.code
                                                                                 }
                                              }).catch((err) => {
                                               console.log(err);
                                              });
          });

exports.create20dollars = functions.region("europe-west3").https.onCall( async (stuff, context) => {
return await axios.post('https://api.commerce.coinbase.com/charges', create20, {
                          headers: { "Content-Type": "application/json", "X-CC-Api-Key": "********", "X-CC-Version": "2018-03-22"},

                          })
                                 .then((res) => {
                                  return {
                                  url: res.data.data.hosted_url,
                                 id: res.data.data.code
                                  }
                                 }).catch((err) => {
                                  console.log(err);
                                 });
          });

exports.create30dollars = functions.region("europe-west3").https.onCall( async (stuff, context) => {
return await axios.post('https://api.commerce.coinbase.com/charges', create30, {
                          headers: { "Content-Type": "application/json", "X-CC-Api-Key": "**********", "X-CC-Version": "2018-03-22"},

                          })
                                 .then((res) => {
                                  return {
                                  url: res.data.data.hosted_url,
                                  id: res.data.data.code
                                  }
                                 }).catch((err) => {
                                  console.log(err);
                                 });
          });

exports.createPartner = functions.region("europe-west3").https.onCall( async (stuff, context) => {
return await axios.post('https://api.commerce.coinbase.com/charges', partner, {
                          headers: { "Content-Type": "application/json", "X-CC-Api-Key": "************", "X-CC-Version": "2018-03-22"},

                          })
                                 .then((res) => {
                                  return {
                                  url: res.data.data.hosted_url,
                                  id: res.data.data.code
                                  }
                                 }).catch((err) => {
                                  console.log(err);
                                 });
          });

exports.checkCrypto = functions.region("europe-west3").https.onCall( async (stuff, context) => {
return await axios.get('https://api.commerce.coinbase.com/charges/' + stuff.message, {
                                                                                       headers: { "Content-Type": "application/json", "X-CC-Api-Key": "*********", "X-CC-Version": "2018-03-22"},

                                                                                     })
                                 .then((res) => {
                                  return {
                                  status: res.data.data.timeline,
                                  }
                                 }).catch((err) => {
                                  console.log('error');
                                 });
          });


