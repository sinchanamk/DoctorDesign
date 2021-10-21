
import 'package:flutter/material.dart';
import 'package:royalmart/General/AppConstant.dart';
import 'package:royalmart/locatization/dlocalization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'General/AnimatedSplashScreen.dart';


Future main() async {


  runApp(new MyApp()

      );



}

class MyApp extends StatefulWidget {

  const MyApp({Key key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale)   {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title:Constant.appname,
      debugShowCheckedModeBanner: false,
        theme: new ThemeData(
            primarySwatch: Colors.orange,),
      locale: _locale,
      supportedLocales: [
        Locale('en','US'),
        Locale('hi','IN')
      ],
      localizationsDelegates:[
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ] ,
      localeResolutionCallback: (deviclocale,supportedLocales){
        for(var local in supportedLocales){
          if(local.languageCode==deviclocale.languageCode && local.countryCode==deviclocale.countryCode){
            return deviclocale;
          }

        }

        return supportedLocales.first;
      },
      home:  AnimatedSplashScreen(),
    );
  }
}