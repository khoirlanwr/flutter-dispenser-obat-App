import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_getx/blocs/user_authentication.dart';
import 'package:todo_getx/widgets/screensize_config.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  bool _obscureText = true;

  _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void signUp(BuildContext context, String email, String password) async {
    String result =
        await Provider.of<UserAuthentication>(context, listen: false)
            .registerAccount(email, password);

    if (result == "register-success") {
      print(result);

      Navigator.pop(context);
    } else {
      print(result);
      // Navigator.pop(context);

      // show snackbar error result
      _scaffoldState.currentState.showSnackBar(SnackBar(
          content: new Text(result), duration: new Duration(seconds: 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);

    final registerBanner = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 2.0,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Disini.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenSizeConfig.safeBlockHorizontal * 11.3,
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

    final passwordConfirmationField = Padding(
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
            controller: confirmPasswordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: 'Konfirmasi password.',
            ),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.5,
                color: Color(0xFF211551)),
          ))
        ],
      ),
    );

    final register = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 1.1,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 12.3),
      child: GestureDetector(
        onTap: () {
          if (passwordController.text == confirmPasswordController.text) {
            signUp(context, emailController.text, passwordController.text);
          } else {
            _scaffoldState.currentState.showSnackBar(SnackBar(
                content: new Text('Password tidak sama'),
                duration: new Duration(seconds: 1)));
          }
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
              'Daftar',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenSizeConfig.safeBlockHorizontal * 4.4,
                  color: Colors.white),
            ),
          ),
        ),
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
            Text(
                _obscureText == true
                    ? 'Lihat password'
                    : 'Sembunyikan password',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.7))
          ],
        ),
      ),
    );

    final backPage = Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 0.3,
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 14),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          child: Center(
            child: Text(
              'Kembali ke halaman login.',
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
            registerBanner,
            SizedBox(height: ScreenSizeConfig.safeBlockVertical * 3),
            emailField,
            SizedBox(
              height: ScreenSizeConfig.safeBlockVertical * 0.5,
            ),
            passwordField,
            SizedBox(
              height: ScreenSizeConfig.safeBlockVertical * 0.5,
            ),
            passwordConfirmationField,
            passwordVisibilityButton,
            SizedBox(height: ScreenSizeConfig.safeBlockVertical * 2.5),
            register,
            SizedBox(height: ScreenSizeConfig.safeBlockVertical * 3.0),
            backPage
          ],
        ),
      ),
    );
  }
}
