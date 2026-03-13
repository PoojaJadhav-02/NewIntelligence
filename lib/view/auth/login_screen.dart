import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_color.dart';
import '../../view_model/login_provider.dart';
import '../../view_model/theme_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    ValueNotifier<bool> obSurePassword = ValueNotifier(true);

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Consumer<LoginProvider>(
          builder: (context, provider, child) {

            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: themeProvider.isDarkMode
                      ? AppColor.primaryColors
                      : AppColor.secondaryColors,
                ),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  /// Email Field
                  TextFormField(
                    controller: provider.usernameController,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Password Field
                  ValueListenableBuilder(
                    valueListenable: obSurePassword,
                    builder: (context, value, child) {

                      return TextFormField(
                        controller: provider.passwordController,
                        obscureText: value,

                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          suffixIcon: IconButton(
                            icon: Icon(
                              value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              obSurePassword.value = !value;
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.tertiaryColors, foregroundColor: AppColor.primaryColors),
                      onPressed: provider.isLoading
                          ? null
                          : () => provider.login(context),

                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Login"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}