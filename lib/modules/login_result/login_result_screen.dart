import 'dart:async';
import 'dart:io';

import 'package:app_expertise/main.dart';
import 'package:app_expertise/modules/login/login_screen.dart';
import 'package:app_expertise/modules/search_screen/search_screen.dart';
import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:app_expertise/shared/network/local/cache_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

class LoginResultScreen extends StatefulWidget {

  @override
  State<LoginResultScreen> createState() => _LoginResultScreenState();
}

class _LoginResultScreenState extends State<LoginResultScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var phoneController = TextEditingController();


  @override
  void initState() {
    getConnectivity();
    super.initState();
  }


  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          print('connection : $isDeviceConnected');
          // for (var element in cubitt.tasks) {
          //   print('ddddddddddddddd ${element[1]}');
          //   cubitt.createContact(
          //     name: element['name'],
          //     email: element['email'],
          //     phone: element['phone'],
          //     isConnect: isDeviceConnected,
          //   );
          //   cubitt.deleteDataFromDb(id: element['id']);
          // }

          setState(() {
          },);
          if (!isDeviceConnected) {
            //showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  // var rr = [];
  @override
  Widget build(BuildContext context) {
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is AppCreateContactState) {
              Navigator.pop(context);
            } else if (state is AppSyncDataFromLocalDbState) Fluttertoast.showToast(
              msg: "Data Synchronized Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);
        //     print(cubit.tasks.length);
        //     if(cubit.tasks.length > 0) {
        //   cubit
        //       .synchronizeData(client, cubit.tasks)
        //       .then((value) => print('dddddddddddddooooone'))
        //       .catchError((onError) => print('nnnnnnnnnoooot ddone $onError'));
        // }
        //for (var element in cubit.tasks) {
             //    print('ddddddddddddddd ${element['name']}');
             //    cubit.createContact(
             //      name: element['name'],
             //      email: element['email'],
             //      phone: element['phone'],
             //    );
             //    //cubit.deleteDataFromDb(id: element['id']);
             //  }
            bool isLogin = CacheHelper.getData(key: 'isLogin');
            return Scaffold(
              key: scaffoldKey,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  {
                    if (cubit.bol) {
                      if (formKey.currentState!.validate()) {
                        if(isDeviceConnected){
                          cubit.createContact(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }else{
                          cubit.insertToDb(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text
                          );
                        }

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
                  IconButton(
                    onPressed: () => cubit.synchronizeData(client, cubit.tasks),
                    icon: Icon(
                      Icons.sync,
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
                        CacheHelper.saveData(key: 'sessionId', value: '');
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
                  ),
                ],
              ),
                      body: !isDeviceConnected ?
                      ListView.separated(
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsetsDirectional.only(start: 20.0),
                            child: Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                          itemCount: cubit.tasks.length,
                          itemBuilder: (context, index) => buildListItemSql(cubit.tasks[index],context))
                      :
                      FutureBuilder(
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
  }
  showDialogBox() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('No Connection'),
      content: const Text('Please check your internet connectivity'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
