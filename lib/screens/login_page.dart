import 'package:flutter/material.dart';
import 'package:todo_getx/blocs/auth_status.dart';
import 'package:todo_getx/blocs/user_authentication.dart';
import 'package:todo_getx/widgets/screensize_config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _onSaveDataLoggedIn() {
    authStatus.saveData("null-login");
  }

  loginAccount(String email, String password) {
    userAuthentication.loginAccount(
        emailController.text, passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    _onSaveDataLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);

    final loginBanner = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 2.0,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenSizeConfig.safeBlockHorizontal * 11.6,
                color: Colors.black87),
          ),
          SizedBox(
            height: ScreenSizeConfig.safeBlockVertical * 0.3,
          ),
          Text('Silahkan isi form dibawah.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.0))
        ],
      ),
    );

    final emailField = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 0.3,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 12.3),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: ScreenSizeConfig.safeBlockHorizontal * 4.0),
            child: Icon(
              Icons.mail,
              color: Colors.blue,
            ),
          ),
          Expanded(
              child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Email',
            ),
            style: TextStyle(
                fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF211551)),
          ))
        ],
      ),
    );

    final passwordField = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 0.3,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 12.3),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: ScreenSizeConfig.safeBlockHorizontal * 4.0),
            child: Icon(Icons.lock, color: Colors.blue),
          ),
          Expanded(
              child: TextField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: 'Password.',
            ),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.5,
                color: Color(0xFF211551)),
          ))
        ],
      ),
    );

    final passwordVisibilityButton = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 0.3,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 13.5),
      child: GestureDetector(
        onTap: _togglePasswordVisibility,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: ScreenSizeConfig.safeBlockHorizontal * 4.4),
              child: Icon(
                _obscureText == true ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
                size: ScreenSizeConfig.safeBlockHorizontal * 4.0,
              ),
            ),
            Expanded(
                child: Text(
              _obscureText == true ? 'Lihat password' : 'sembunyikan password',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.7),
            ))
          ],
        ),
      ),
    );

    final login = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 1.1,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 12.3),
      child: GestureDetector(
        onTap: () {
          loginAccount(emailController.text, passwordController.text);
        },
        child: Container(
          width: double.infinity,
          height: ScreenSizeConfig.safeBlockVertical * 7.0,
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: BorderRadius.circular(
                ScreenSizeConfig.safeBlockHorizontal * 1.6),
          ),
          child: Center(
            child: Text(
              'Masuk',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.4,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );

    final redirectPage = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 0.3,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 14),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/register');
        },
        child: Container(
          child: Center(
            child: Text(
              'Silahkan daftar jika belum punya akun.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.5,
                  color: Colors.black54),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
              horizontal: ScreenSizeConfig.safeBlockHorizontal * 6),
          children: [
            loginBanner,
            SizedBox(
              height: ScreenSizeConfig.safeBlockVertical * 3,
            ),
            emailField,
            SizedBox(
              height: ScreenSizeConfig.safeBlockVertical * 0.5,
            ),
            passwordField,
            passwordVisibilityButton,
            SizedBox(
              height: ScreenSizeConfig.safeBlockVertical * 2.5,
            ),
            login,
            SizedBox(height: ScreenSizeConfig.safeBlockVertical * 3.0),
            redirectPage
          ],
        ),
      ),
    );
  }
}
