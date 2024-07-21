import 'package:flutter/material.dart';
import '../controllers/signup_screen_controller.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

    SignupScreenController signupScreenController = SignupScreenController();

    @override
    void initState() {
        signupScreenController.init();
        super.initState();
    }

    @override
    void dispose() {
        signupScreenController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: Container(),
        );
    }
}

