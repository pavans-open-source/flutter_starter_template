import 'package:flutter/material.dart';
import '../controllers/home_screen_controller.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

    HomeScreenController homeScreenController = HomeScreenController();

    @override
    void initState() {
        homeScreenController.init();
        super.initState();
    }

    @override
    void dispose() {
        homeScreenController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: Container(),
        );
    }
}

