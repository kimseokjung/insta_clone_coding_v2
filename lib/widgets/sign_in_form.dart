import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/constants/auth_input_deco.dart';
import 'package:instagram_clone_coding/constants/common_size.dart';
import 'package:instagram_clone_coding/home_page.dart';
import 'package:instagram_clone_coding/models/firebase_auth_state.dart';
import 'package:instagram_clone_coding/widgets/or_divider.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Form(
        key: _formKey,
        child: ListView(children: [
          SizedBox(
            height: common_l_gap,
          ),
          Image.asset('assets/images/insta_text_logo.png'),
          TextFormField(
            cursorColor: Colors.black54,
            controller: _emailController,
            decoration: textInputDeco('Email'),
            validator: (text) {
              if (text.isNotEmpty && text.contains("@")) {
                return null;
              } else {
                return '이메일을 확인해 주세요';
              }
            },
          ),
          SizedBox(
            height: common_l_gap,
          ),
          TextFormField(
            cursorColor: Colors.black54,
            controller: _passwordController,
            obscureText: true,
            decoration: textInputDeco('Password'),
            validator: (text) {
              if (text.isNotEmpty && text.length > 5) {
                return null;
              } else {
                return '비밀번호를 확인해 주세요';
              }
            },
          ),
          TextButton(
            onPressed: () {},
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgotten Password?',
                style: TextStyle(color: Colors.blue[300]),
              ),
            ),
          ),
          _submitButton(context),
          SizedBox(
            height: common_s_gap,
          ),
          OrDivider(),
          TextButton.icon(
              onPressed: () {
                Provider.of<FirebaseAuthState>(context, listen: false)
                    .loginWithFacebook(context);
              },
              style: TextButton.styleFrom(primary: Colors.blue),
              icon: ImageIcon(AssetImage('assets/images/facebook.png')),
              label: Text('Login with Facebook'))
        ]),
      ),
    );
  }

  TextButton _submitButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          // 서버전달
          print('Validation success!!');
          Provider.of<FirebaseAuthState>(context, listen: false)
              .login(context,email: _emailController.text, password: _passwordController.text);
        }
      },
      child: Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
