import 'package:flutter/material.dart';
import 'package:ysi/network_utils/api.dart';
import 'package:ysi/screen/forgotPassword.dart';
import 'package:ysi/screen/home.dart';
import 'package:ysi/services/sharedPref.dart';
// import 'package:ysi/screen/register.dart';
// import 'package:ysi/widgets/styles.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  var passwordErrorMessage;
  var emailErrorMessage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,

      // backgroundColor: darkBlueGrey,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: unfocus,
        child: SingleChildScrollView(
          child: Container(
            height: _height,
            width: _width,
            child: SafeArea(
              child: Column(
                // alignment: Alignment.topCenter,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: _height * .1,
                          ),
                          Image.asset(
                            'web/favicon.png',
                            width: 64,
                          ),
                          Text(
                            '曜聖國際',
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontFamily: 'googlesan'),
                          ),
                          Text(
                            '問卷系統',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white70),
                          ),
                          SizedBox(
                            height: 64,
                          ),
                          Card(
                            elevation: 4.0,
                            color: Colors.white,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 8, right: 8, bottom: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          scrollPadding: EdgeInsets.all(90),
                                          textInputAction: TextInputAction.next,
                                          // scrollPadding: EdgeInsets.only(
                                          //     bottom: MediaQuery.of(context)
                                          //         .viewInsets
                                          //         .bottom),
                                          style: TextStyle(
                                              color: Color(0xFF000000)),
                                          cursorColor: Color(0xFF9b9b9b),
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.grey,
                                            ),
                                            hintText: "Email",
                                            hintStyle: TextStyle(
                                                color: Color(0xFF9b9b9b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          validator: (emailValue) {
                                            if (emailValue!.isEmpty) {
                                              return '請輸入註冊的E-Mail';
                                            }
                                            email = emailValue;
                                            return emailErrorMessage;
                                          },
                                          onChanged: (phonenumber) {
                                            emailErrorMessage = null;
                                          },
                                        ),
                                        TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          scrollPadding: EdgeInsets.all(90),
                                          textInputAction: TextInputAction.done,
                                          // scrollPadding: EdgeInsets.all(
                                          //     MediaQuery.of(context)
                                          //         .viewInsets
                                          //         .bottom),
                                          style: TextStyle(
                                              color: Color(0xFF000000)),
                                          cursorColor: Color(0xFF9b9b9b),
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.vpn_key,
                                              color: Colors.grey,
                                            ),
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                                color: Color(0xFF9b9b9b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          validator: (passwordValue) {
                                            if (passwordValue!.isEmpty) {
                                              return '請輸入密碼';
                                            }
                                            password = passwordValue;
                                            return passwordErrorMessage;
                                          },
                                          onEditingComplete: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _login();
                                            }
                                          },
                                          onChanged: (phonenumber) {
                                            passwordErrorMessage = null;
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ElevatedButton(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 8,
                                                  left: 10,
                                                  right: 10),
                                              child: Text(
                                                _isLoading ? '認證中...' : '登入',
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _login();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                            child: Text(
                              '忘記密碼了嗎？',
                              style: TextStyle(color: Color(0xFFE7E5E5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    debugPrint('login!');
    unfocus();
    setState(() {
      _isLoading = true;
    });
    var data = {'email': email, 'password': password};

    var res = await Network().authData(data, '/login', context);

    if (res['success']) {
      SharedPref().saveUserData(res);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } else {
      if (res['message']['email'] != null) {
        debugPrint(res['message']['email'].join(''));
        emailErrorMessage = res['message']['email'].join('');
      }
      if (res['message']['password'] != null) {
        debugPrint(res['message']['password'].join(''));
        passwordErrorMessage = res['message']['password'].join('');
      }
      _formKey.currentState!.validate();
    }

    setState(() {
      _isLoading = false;
    });
  }
}
