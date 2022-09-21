import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:house_management/utils/navigation.dart';

import '../homepage/view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool hide = true;

  void login(String username, String password) {
    toScreen(context, const Home());
  }

  toggleShowPassword() {
    setState(() {
      hide = !hide;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScaffoldPage(
      content: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TextBox(
                  padding: const EdgeInsets.all(15),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(FluentIcons.temporary_user),
                  ),
                  controller: _username,
                  header: 'Username',
                  placeholder: 'Type your username',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextBox(
                padding: const EdgeInsets.all(15),
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(FluentIcons.password_field),
                ),
                controller: _password,
                obscureText: hide,
                header: 'Password',
                placeholder: 'Type your password',
                suffix: IconButton(
                  icon: Icon(hide
                      ? mat.Icons.visibility_outlined
                      : mat.Icons.visibility_off_outlined),
                  onPressed: toggleShowPassword,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              IconButton(
                icon: const Icon(
                  FluentIcons.forward,
                  size: 20,
                ),
                onPressed: () => login(
                  _username.text.trim(),
                  _password.text.trim(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
