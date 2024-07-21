import 'package:flutter/material.dart';
import '../controllers/login_screen_controller.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

    LoginScreenController loginScreenController = LoginScreenController();

    @override
    void initState() {
        loginScreenController.init();
        super.initState();
    }

    @override
    void dispose() {
        loginScreenController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: Container(),
        );
    }
}

