import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:konkurs_app/telegram/services/telegram_service.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:tdlib/td_api.dart' show TdError;

class TelegramLogin extends StatefulWidget {
  static final String id = 'telegram_screen';
  TelegramLogin();

  @override
  _TelegramLoginState createState() => _TelegramLoginState();
}

class _TelegramLoginState extends State<TelegramLogin> {
  final String title = 'Авторизация';
  final _phoneNumberController = TextEditingController();
  final _countryNameController = TextEditingController();
  Country _selectedCountry;
  bool _canShowButton = false;
  String _phoneNumberError;
  bool _loadingStep = false;

  void phoneNumberListener() {
    if (_phoneNumberController.text.isEmpty) {
      if (_canShowButton) {
        setState(() => _canShowButton = false);
      }
    } else {
      if (!_canShowButton) {
        setState(() => _canShowButton = true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(phoneNumberListener);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _countryNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*if (_selectedCountry == null) {
      Locale locale = Localizations.localeOf(context);
      _selectedCountry =
          CountryPickerUtils.getCountryByIsoCode(locale.countryCode);
      _countryNameController.text = _selectedCountry.name;
    }*/
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: LightColors.kDarkBlue,
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                onTap: _openCountryPickerDialog,
                controller: _countryNameController,
                decoration: InputDecoration(
                  labelText: "Страна",
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: (_selectedCountry != null)
                            ? '+${_selectedCountry.phoneCode}  '
                            : ' +  ',
                        alignLabelWithHint: true,
                        labelText: "Телефон",
                        errorText: _phoneNumberError ?? null,

                        errorStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        //contentPadding: EdgeInsets.zero
                      ),
                      onSubmitted: _nextStep,
                      autofocus: true,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _phoneNumberError == null
                      ? 'Мы отправим SMS на ваш номер для подтверждения.'
                      : '',
                  style: TextStyle(color: Colors.grey, fontSize: 15.0),
                ),
              )
            ],
          )
        ],
      ),

      floatingActionButton: _canShowButton
          ? FloatingActionButton(
              backgroundColor: LightColors.kDarkBlue,
              onPressed: () => _nextStep(_phoneNumberController.text),
              tooltip: 'checkphone',
              child: _loadingStep
                  ? CircularProgressIndicator(
                      backgroundColor: LightColors.kLightYellow,
                    )
                  : Icon(Icons.navigate_next),
            )
          : null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _nextStep(String value) async {
    setState(() {
      _loadingStep = true;
    });
    context.read<TelegramService>().setAuthenticationPhoneNumber(
          (_selectedCountry != null)
              ? '+${_selectedCountry.phoneCode}$value'
              : value,
          onError: _handelError,
        );
  }

  void _handelError(TdError error) async {
    setState(() {
      _loadingStep = false;
      _phoneNumberError = error.message;
    });
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Поиск...'),
            isSearchable: true,
            title: Text('Код страны'),
            onValuePicked: _onPickCountry,
            itemBuilder: _buildDialogItem,
          ),
        ),
      );

  void _onPickCountry(Country country) {
    setState(() {
      _selectedCountry = country;
      _countryNameController.text = country.name;
    });
  }

  Widget _buildDialogItem(Country country, {dialog = true}) =>
      Row(children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Text("+${country.phoneCode}"),
        SizedBox(width: 8.0),
        Flexible(
          child: Text(country.name),
        )
      ]);
}
