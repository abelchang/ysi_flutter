import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
// import 'package:boobook_flutter/screen/register.dart';
// import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:ysi/providers/authProviders.dart';
import 'package:ysi/screen/login.dart';
import 'package:ysi/widgets/styles.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var email;
  String? resMessage;

  final pageController = PageController(initialPage: 0);
  final _fformKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  bool isLoading = false;
  String hintMessage = '填入E-Mail，將會寄送重設密碼信件到您信箱';

  int pageChanged = 0;

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

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
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.info_outline_rounded),
      //   onPressed: () {
      //     Navigator.push(context, ScaleRoute(page: MainPage()));
      //   },
      // ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: unfocus,
        child: SingleChildScrollView(
          child: Container(
            height: _height,
            width: _width,
            child: SafeArea(
              child: Column(
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
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  SizedBox(
                    height: 64,
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: blueGrey,
                                onSurface: Colors.white,
                              ),
                          inputDecorationTheme: InputDecorationTheme(
                            errorStyle: TextStyle(color: pinkLite),
                          ),
                        ),
                        child: Card(
                          elevation: 10.0,
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
                                Text(
                                  '忘記密碼',
                                  style: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                                Form(
                                  key: _fformKey,
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(' ')
                                    ],
                                    // scrollPadding: EdgeInsets.only(
                                    //   bottom: MediaQuery.of(context)
                                    //           .viewInsets
                                    //           .bottom +
                                    //       64,
                                    // ),
                                    style: TextStyle(color: Color(0xFF000000)),
                                    cursorColor: Color(0xFF9b9b9b),
                                    decoration: InputDecoration(
                                      errorText: resMessage ?? null,
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.grey,
                                      ),
                                      hintText: "E-Mail",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    // autofillHints: [AutofillHints.email],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (!EmailValidator.validate(
                                          value.toString())) {
                                        return 'E-Mail格式有誤，請再次檢查';
                                      }
                                      if (value!.isEmpty) {
                                        return '請輸入您的E-Mail';
                                      }
                                      email = value;
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        resMessage = null;
                                      });
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    onEditingComplete: () async {
                                      await sendResetMail();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  hintMessage,
                                  style: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await sendResetMail();
                                      },
                                      child: isLoading
                                          ? Text('寄送中...請稍後！')
                                          : Text('寄送')),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        '重新登入',
                        style: TextStyle(color: Color(0xFFE7E5E5)),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future sendResetMail() async {
    unfocus();
    if (_fformKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var res = await AuthProvider().forgotPassword(email);
      if (res['success']) {
        setState(() {
          resMessage = null;
          hintMessage = res['message'];
          isLoading = false;
        });
      } else {
        setState(() {
          hintMessage = '';
          resMessage = res['message'];
          isLoading = false;
        });
      }
    }
  }
}
