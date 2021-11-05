import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/providers/auth_provider.dart';
import 'package:grocery_delivery_app/screens/login_screen.dart';
import 'package:grocery_delivery_app/widgets/image_picker.dart';
import 'package:grocery_delivery_app/widgets/register_form.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ShopPicCard(),
                  RegisterForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
