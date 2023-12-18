import 'package:brand_kiln_task/screens/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import '../../services/authentication.dart';
import '../home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(10),
    );
    //
    var btnSize = Size(MediaQuery.of(context).size.width * 0.8, 50);
    //
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              scrollDirection: Axis.vertical,
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (!value!.contains('@')) {
                          return 'Badly formatted';
                        }
                        return null;
                      },
                      autofocus: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: inputBorder,
                        hintText: 'Email',
                        label: const Text('Email'),
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        focusedBorder: inputBorder,
                        enabledBorder: inputBorder,
                        contentPadding: const EdgeInsets.all(8.0),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Must be 6 characters';
                        }
                        return null;
                      },
                      autofocus: false,
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: inputBorder,
                        hintText: 'Password',
                        label: const Text('Password'),
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        focusedBorder: inputBorder,
                        enabledBorder: inputBorder,
                        contentPadding: const EdgeInsets.all(8.0),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: btnSize,
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus;
                        if (key.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          String res = await Authentication().createUser(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          if (res == 'success') {
                            setState(() {
                              isLoading = false;

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: (Text(res)),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Create'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
