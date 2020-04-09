import 'package:bitcoinratesampel/NetworkHelper.dart';
import 'package:bitcoinratesampel/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'USD';
  List<double> rate = [0.00, 0.00, 0.00];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${rate[crypto.BTC.index].toStringAsFixed(2)} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ETH = ${rate[crypto.ETH.index].toStringAsFixed(2)} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 LTC = ${rate[crypto.LTC.index].toStringAsFixed(2)} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: /*Platform.isIOS ? iOSPicker() :*/androidDropdownButton()
          ),
        ],
      ),
    );
  }

  DropdownButton<String> androidDropdownButton() {

    var dropdownItems = List<DropdownMenuItem<String>>();
    for (String currency in currenciesList) {
      var item = DropdownMenuItem(child: Text(currency), value: currency);
      dropdownItems.add(item);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) async {
        selectedCurrency = value;
        updateUI(await getRate(crypto.BTC), crypto.BTC);
        updateUI(await getRate(crypto.ETH), crypto.ETH);
        updateUI(await getRate(crypto.LTC), crypto.LTC);
      },
    );
  }

  CupertinoPicker iOSPicker(){

    var pickerItems = List<Text>();
    for (String currency in currenciesList) {
      pickerItems.add(Text(
        currency,
        style: TextStyle(color: Colors.white),
      ));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        selectedCurrency = currenciesList[selectedIndex];
        updateUI(await getRate(crypto.BTC), crypto.BTC);
        updateUI(await getRate(crypto.ETH), crypto.ETH);
        updateUI(await getRate(crypto.LTC), crypto.LTC);
      },
      children: pickerItems,
      backgroundColor: Colors.lightBlue,
    );
  }

  void updateUI(dynamic data, crypto type){
    setState(() {
      print(data);
      if (data == null){
        rate.removeRange(0, rate.length);
        for(int i = 0; i < cryptoList.length; i++){
          rate.add(0.00);
        }
        return;
      }
      rate[type.index] = data['rate'];
    });
  }

  Future<dynamic> getRate(crypto type) async{
    String coinType = 'BTC';
    if(type == crypto.ETH){
      coinType = 'ETH';
    }else if(type == crypto.LTC){
      coinType = 'LTC';
    }

    String url = 'http://rest.coinapi.io/v1/exchangerate/$coinType/$selectedCurrency?apikey=apikey';
    NetworkHelper networkHelper = NetworkHelper(url);
    return await networkHelper.getData();
  }

}

