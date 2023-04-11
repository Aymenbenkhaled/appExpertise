import 'package:app_expertise/modules/login_result/login_result_screen.dart';
import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKea = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKea,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      defaultFormField(
                        suffpressd: () {},
                        controller: emailController,
                        label: 'Email',
                        type: TextInputType.emailAddress,
                        prefIcon: Icons.email_rounded,
                        radius: 20,
                        //text: 'Email empty',
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Email empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      defaultFormField(
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        label: 'Password',
                        obscureText: cubit.isVisible,
                        //text: 'password must not be empty',
                        prefIcon: Icons.lock,
                        suffIcon: cubit.isVisible ? Icons.visibility : Icons.visibility_off,
                        suffpressd: () {
                          cubit.changeVisibility();
                        },
                        radius: 20,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Password incorrect';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Center(
                        child: defaultBotton(
                          function: () {
                            if (formKea.currentState!.validate()) {
                              print(
                                  '${emailController.text} // ${passwordController.text}'
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>LoginResultScreen(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  )
                              );
                            }
                          },
                          text: 'login',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?'),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              print(
                                  '${emailController.text} //// ${passwordController.text}');
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );      }
    );
  }
}

