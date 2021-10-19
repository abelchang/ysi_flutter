import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:ysi/screen/forgotPassword.dart';
import 'package:ysi/screen/home.dart';
import 'package:ysi/screen/login.dart';
import 'package:ysi/screen/qaPAge.dart';
import 'package:ysi/services/projectSerivce.dart';
import 'package:ysi/services/sharedPref.dart';
import 'package:ysi/widgets/styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<Map<String, dynamic>> checkLogin() => ProjectService().checkIfLogin();
  final spinkit = SpinKitChasingDots(
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '曜聖國際問卷系統',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      onGenerateRoute: (settings) {
        List<String> pathComponents = settings.name!.split('/');
        switch (settings.name) {
          case '/':
            break;
          default:
            return MaterialPageRoute(
              builder: (context) => Qapage(
                code: pathComponents.last,
              ),
            );
        }
      },
      supportedLocales: [
        const Locale('en'),
        const Locale.fromSubtags(languageCode: 'zh'), // generic Chinese 'zh'
        const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans'), // generic simplified Chinese 'zh_Hans'
        const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant'), // generic traditional Chinese 'zh_Hant'
        const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans',
            countryCode: 'CN'), // 'zh_Hans_CN'
        const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'TW'), // 'zh_Hant_TW'
        const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'HK'), // 'zh_Hant_HK'
      ],
      locale: const Locale.fromSubtags(
          languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
      theme: _buildShrineTheme(),
      home: FutureBuilder(
        future: checkLogin(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return spinkit;
            default:
              if (snapshot.hasData) {
                if ((snapshot.data! as Map)['success'] == true) {
                  return Home();
                } else {
                  SharedPref().removeUserData();
                  return Login();
                }
              } else if (snapshot.hasError) {
                print('snapshot has no data!');
                // developer.log(
                //   'log me',
                //   name: 'my.app.main.snapshot.error',
                //   error: jsonEncode(snapshot.error),
                // );
                // print('Error:${snapshot.error}')
                SharedPref().removeUserData();
                return Login();
              } else {
                return spinkit;
              }
          }
        },
      ),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    var token = await SharedPref().getToken();
    if (token.isNotEmpty) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = Home();
    } else {
      child = Login();
    }
    return Scaffold(
      body: child,
    );
  }
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      secondary: blueGrey,
      primary: darkBlueGrey3,
    ),

    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'googlesan',
        ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'googlesan',
        ),

    // toggleableActiveColor: shrinePink400,
    // primaryColor: lightBlue,
    // scaffoldBackgroundColor: Color(0xFF2B2727),
    scaffoldBackgroundColor: darkBlueGrey3,

    // cardColor: shrineBackgroundWhite,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBlueGrey3,
    ),
    errorColor: pinkLite,
    bottomAppBarColor: lightBlue,
    backgroundColor: darkBlueGrey3,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        primary: lightBrown,
        textStyle: TextStyle(
          fontFamily: 'googlesan',
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.white,
        textStyle: TextStyle(
          fontFamily: 'googlesan',
        ),
      ),
    ),
    canvasColor: darkBlueGrey3,
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: blueGrey)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: pinkLite),
      ),
    ),
    // primaryIconTheme: _customIconTheme(base.iconTheme),
    // textTheme: _buildShrineTextTheme(base.textTheme),
    // primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    // accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    // iconTheme: _customIconTheme(base.iconTheme),

    cardTheme: CardTheme(
      color: whiteSmoke,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
    ),
  );
}
