import 'package:app_expertise/modules/login_result/login_result_screen.dart';
import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../main.dart';


class LoginScreen extends StatelessWidget
{
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKea = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {
          if (state is AppAuthErrorState) Fluttertoast.showToast(
              msg: "Username Or Password Incorrect",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
          );
          //if (state is AppAuthSuccessState) AppCubit.get(context).fetchContacts();
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
                            if(value!.isEmpty) {
                              return 'Email Incorrect';
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
                          onSubmit: (value) {
                            if (formKea.currentState!.validate()) {
                              cubit.authentifiaction(
                                  emailController.text,
                                  passwordController.text,
                                  context
                              );
                            }
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Password Incorrect';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Center(
                          child: ConditionalBuilder(
                            condition: state is! AppAuthLoadingState ,
                            builder: (context) => defaultBotton(
                              //width: double.infinity,
                              //radius: 0,
                              function: () {
                                if (formKea.currentState!.validate()) {
                                  cubit.authentifiaction(
                                      emailController.text,
                                      passwordController.text,
                                      context
                                  );
                                }
                              },
                              text: 'login',
                            ),
                            fallback:(context) => Center(child: CircularProgressIndicator()),
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
                                  color: Colors.deepOrange,
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



