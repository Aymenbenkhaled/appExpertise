import 'dart:io';

import 'package:app_expertise/main.dart';
import 'package:app_expertise/modules/login/login_screen.dart';
import 'package:app_expertise/modules/search_screen/search_screen.dart';
import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:app_expertise/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class LoginResultScreen extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  // var rr = [];
  // void getr() async{
  //    rr = await SessionManager().get("value");
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCreateContactState) Navigator.pop(context);
      },
      builder: (context, state) {
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            //getr();
            return Scaffold(
              key: scaffoldKey,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  {
                    if (cubit.bol) {
                      if (formKey.currentState!.validate()) {
                        cubit.createContact(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text);
                      }
                    } else {
                      scaffoldKey.currentState!
                          .showBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30)
                                )
                            ),
                            //backgroundColor: Colors.grey[300],
                            (context) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultFormField(
                                      radius: 20,
                                      controller: nameController,
                                      type: TextInputType.text,
                                      label: 'Contact Name',
                                      prefIcon: Icons.person,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Name empty';
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    defaultFormField(
                                      radius: 20,
                                      controller: emailController,
                                      type: TextInputType.text,
                                      label: 'Contact Email',
                                      prefIcon: Icons.email,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Name empty';
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    defaultFormField(
                                      radius: 20,
                                      controller: phoneController,
                                      type: TextInputType.text,
                                      label: 'Contact Phone',
                                      prefIcon: Icons.phone,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Name empty';
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .closed
                          .then((value) {
                        cubit.ChangeBottomSheetState(
                            icon: Icons.edit, boll: false);
                      });
                      cubit.ChangeBottomSheetState(
                          icon: Icons.add, boll: true);
                    }
                  }
                  ;
                },
                child: Icon(cubit.fabIcon),
              ),
              appBar: AppBar(
                title: Text('Contacts'),
                actions: [
                  IconButton(
                    onPressed: () async {
                      navPush(context, SearchScreen());
                      // await cubit.getRecord();
                    },
                    icon: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                  defaultBotton(
                    function: () async {
                      try {
                        // Log out
                        print('\nDestroying session');
                        await client.destroySession();
                        CacheHelper.putData(key: 'isLogin', value: false);
                        CacheHelper.saveData(key: 'username', value: '');
                        CacheHelper.saveData(key: 'password', value: '');
                        navPushAndFinish(context, LoginScreen());
                      } on OdooException catch (e) {
                        // Cleanup on odoo exception
                        print(e);
                        await subscription.cancel();
                        await loginSubscription.cancel();
                        await inRequestSubscription.cancel();
                        client.close();
                        exit(-1);
                      }
                    },
                    text: 'LOGOUT',
                    width: 80,
                    height: 10,
                    textSize: 11,
                  )
                ],
              ),
              // body: RefreshIndicator(
              //   onRefresh: () async {
              //     // cubit.fetchContacts();
              //     // await cubit.getRecord();
              //     print('kkkkkk : ${cubit.r}');
              //   },
              //   child: Center(
              //     child: ListView.separated(
              //       itemCount: rr.length,
              //       itemBuilder: (context, index) {
              //         return buildListItem(rr[index], context);
              //       },
              //       separatorBuilder: (context, index) => buildSeparator(),
              //     ),
                      body: FutureBuilder(
                          future: cubit.fetchContacts(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.separated(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    final record =
                                        snapshot.data[index] as Map<String, dynamic>;
                                    return buildListItem(record, context);
                                  },
                                  separatorBuilder: (context, index) =>
                                      buildSeparator());
                            } else {
                              if (snapshot.hasError)
                                return Center(child: Text('Unable to fetch data'));
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                //),
              //),
            );
          },
        );
      },
    );
  }
}
