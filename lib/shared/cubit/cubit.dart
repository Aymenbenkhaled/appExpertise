import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_expertise/main.dart';
import 'package:app_expertise/modules/login/login_screen.dart';
import 'package:app_expertise/modules/login_result/login_result_screen.dart';
import 'package:app_expertise/modules/printable_data/printable_data.dart';
import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/network/local/cache_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit()
      : super(
          AppInitialState(),
        );


  static AppCubit get(context) => BlocProvider.of(context);
  bool darkLight = true;
  bool b = false;
  bool isVisible = true;

  void changeVisibility() {
    isVisible = !isVisible;
    emit(AppChangePswVisibilityState());
  }

  late final headers;
  void authentifiaction(emailController, passwordController, context) async {

    bool isLogin = CacheHelper.getData(key: 'isLogin');
    emit(AppAuthLoadingState());
    // if (isLogin) {
    //     await client
    //         .authenticate(
    //             'test_aymen', '${emailController}', '${passwordController}')
    //         .then((value) async {
    //           final res = await client.callRPC('/web/session/modules', 'call', {});
    //           print('zzzzzzzzzzz ${value.id}');
    //           CacheHelper.putData(key: 'direction', value: false);
    //           emit(AppAuthSuccessState());
    //           final session = value;
    //       image_field = session.serverVersionInt >= 13 ? 'image_1920' : 'image_small';
    //     }).catchError((onError) {
    //       print('the error of Auth : ${onError}');
    //       emit(AppAuthErrorState());
    //     });
    //   } else {
      await client
          .authenticate(
          'test_aymen', '${emailController}', '${passwordController}')
          .then((value) async {
        final res = await client.callRPC('/web/session/modules', 'call', {});
        CacheHelper.saveData(key: 'username', value: emailController);
        CacheHelper.saveData(key: 'password', value: passwordController);
        CacheHelper.saveData(key: 'sessionId', value: value.id);
        CacheHelper.putData(key: 'isLogin', value: true).then((value) {
          if (value) {
            navPushAndFinish(
                context,
                LoginResultScreen()
            );
          }
        });
        emit(AppAuthSuccessState());
      }).catchError((onError) {
        print('the error of Auth : ${onError}');
        emit(AppAuthErrorState());
      });
   // }
  }

  var r = [];
  late final image_field;

  Future<dynamic> fetchContacts() async {
    bool isLogin = CacheHelper.getData(key: 'isLogin');
    String username = CacheHelper.getData(key: 'username');
    String password = CacheHelper.getData(key: 'password');
    final s = CacheHelper.getData(key: 'sessionId');
    print('aaaaaaaaaaaaaaaaaaaaaa $s');
    print('${username} ///////// ${password}');

    if (isLogin) {
      await client
          .authenticate(
              'test_aymen', '${username}', '${password}')
          .then((value) async {
            print('zzzzzzzzzzz ${value.id}');
            //header = value;
            //clientt = OdooClient('https://ab87-197-203-125-207.ngrok-free.app',value);
            // ssession = value;
            // final session = value;
        //image_field = session.serverVersionInt >= 13 ? 'image_1920' : 'image_small';
      }).catchError((onError) {print(onError);});
    }
    return r = await client.callKw({
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': [
          'id',
          'name',
          'email',
          'phone',
          '__last_update',
          'avatar_128',
          'image_128',
          'image_1920'
        ],
        'limit': 80,
      },
    });
  }



  Future<dynamic> getRecord() {
    return Future(() => print('aaaaaa ${r}'));
  }

  Future<dynamic> fetchFacturation() async {
    return r = await client.callKw({
      'model': 'account.move',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': [
          'id',
          'name',
          'invoice_date',
          'partner_id',
          'invoice_partner_display_name',
          'invoice_line_ids',
          'amount_total_signed',
          'invoice_payment_term_id',
          'currency_id',
          'tax_totals_json',
          'amount_residual'
        ],
        'limit': 80,
      },
    });
  }

  var partner_id;

  IconData fabIcon = Icons.edit;
  bool bol = false;

  void createContact({
    required String name,
    required String email,
    required String phone,
  }) async {
    bool isLogin = CacheHelper.getData(key: 'isLogin');
    String username = CacheHelper.getData(key: 'username');
    String password = CacheHelper.getData(key: 'password');
    final s = CacheHelper.getData(key: 'sessionId');
    print('aaaaaaaaaaaaaaaaaaaaaa $s');
    print('${username} ///////// ${password}');

    if (isLogin) {
      await client
          .authenticate(
          'test_aymen', '${username}', '${password}')
          .then((value) async {
        print('zzzzzzzzzzz ${value.id}');
        //header = value;
        //clientt = OdooClient('https://ab87-197-203-125-207.ngrok-free.app',value);
        // ssession = value;
        // final session = value;
        //image_field = session.serverVersionInt >= 13 ? 'image_1920' : 'image_small';
      }).catchError((onError) {
        print(onError);
      });
    }
    await client.callKw({
      'model': 'res.partner',
      'method': 'create',
      'args': [
        {
          'name': name,
          //'avatar_128' : 'http://146.59.159.198:4515/web/image?model=res.partner&field=avatar_128&id=7',
          'email': email,
          'phone': phone
        },
      ],
      'kwargs': {},
    }).then((value) {
      print('sayiiiiiiiiiiiiii $value');
      emit(AppCreateContactState());
      //fetchContacts();
      //emit(AppFetchContactState());
      partner_id = value;
    }).catchError((er) => print('the errrrrrrrrrrrrrroooooor iss : ${er}'));


  }

  void updateContact(
      {required Map<String, dynamic> record,
      required name,
      required phone,
      required email}) async {
    partner_id = record['id'];
    // print(name);
    //print(phone);
    // print(email);
    var namee;
    var phonee;
    var emaill;
    name == '' ? namee = record['name'] : namee = name;
    phone == '' ? phonee = record['phone'] : phonee = phone;
    email == '' ? emaill = record['email'] : emaill = email;
    await client.callKw({
      'model': 'res.partner',
      'method': 'write',
      'args': [
        partner_id,
        {
          'is_company': true,
          'name': '$namee',
          'phone': '$phonee',
          'email': '$emaill',
          //'image_1920' : 'assets/images/img.jpg'
        },
      ],
      'kwargs': {},
    }).then((value) {
      emit(AppUpdateContactState());
      print('contact updated');
      //fetchContacts();
      //emit(AppFetchContactState());
    });
  }

  void ChangeBottomSheetState({
    required IconData icon,
    required bool boll,
  }) {
    bol = boll;
    fabIcon = icon;
    emit(AppChageBottomSheetState());
  }

  Future<void> printDoc(record) async {
    var unique = record['__last_update'] as String;
    String sess = CacheHelper.getData(key: 'sessionId');
    final headers = {
      'Cookie': 'session_id=$sess',
    };
    unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
    final avatarUrl =
    //'assets/images/img.jpg';
        '${client.baseURL}/web/image?model=res.partner&id=${record["id"]}&field=avatar_128&unique=$unique';
    final image = await networkImage(
        "$avatarUrl",
        headers: headers
    );
    final doc = pw.Document();
    //final output = await getTemporaryDirectory();
    //final file = File('${output.path}/example2.pdf');
    //await file.writeAsBytes(await doc.save());

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(image, width: 200, height: 200),
                pw.Text('${record['id']}', style: pw.TextStyle(fontSize: 30)),
                pw.Text('${record['name']}', style: pw.TextStyle(fontSize: 30)),
                pw.Text('${record['email']}',
                    style: pw.TextStyle(fontSize: 30)),
                pw.Text('${record['phone']}',
                    style: pw.TextStyle(fontSize: 30)),
                pw.SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<void> printFacDoc(record) async {
    final image = await imageFromAssetBundle(
      "assets/images/img2.jpg",
    );

    final doc = pw.Document();
    //final output = await getTemporaryDirectory();
    //final file = File('${output.path}/example2.pdf');
    //await file.writeAsBytes(await doc.save());

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(image, width: 200, height: 200),
                pw.Text('${record['id']}', style: pw.TextStyle(fontSize: 30)),
                pw.Text('${record['name']}', style: pw.TextStyle(fontSize: 30)),
                pw.Text('${record['invoice_partner_display_name']}',
                    style: pw.TextStyle(fontSize: 30)),
                pw.Text('${record['amount_total_signed']} DA',
                    style: pw.TextStyle(fontSize: 30)),
                pw.SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  var list = [];

  void getSearch(searchValue) {
    list = [];
    emit(AppGetSearchLoadingState());
    if (searchValue != '')
      for (var element in r) {
        if (element['name'].toLowerCase().contains(searchValue.toLowerCase()))
          list.add(element);
      }
  }

  File? image;
  String? base64Image;
  String? _avatarImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        image = File(pickedFile.path);
        base64Image = base64Encode(image!.readAsBytesSync());

      }
  }

  void updateContactImage(
      {required Map<String, dynamic> record}) async {
    partner_id = record['id'];
    // print(name);
    //print(phone);
    // print(email);

    //var emaill;

    //email == '' ? emaill = record['email'] : emaill = email;
    await client.callKw({
      'model': 'res.partner',
      'method': 'write',
      'args': [
        partner_id,
        {
          'image_1920': base64Image,
          //'image_1920' : 'assets/images/img.jpg'
        },
      ],
      'kwargs': {},
    }).then((value) {
      emit(AppUpdateContactState());
      print('Image updated');
      //fetchContacts();
      //emit(AppFetchContactState());
    });
  }

  late Database db;

  void createDb() {
    openDatabase(
      'myDB.db',
      version: 1,
      onCreate: (db, version) {
        print('db created');
        db
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY,name TEXT,email TEXT,phone TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('the error is ${error.toString()}');
        });
      },
      onOpen: (db) {
        getDataFromDb(db);
        print('db Opened');
      },
    ).then((value) {
      db = value;
      emit(AppCreateDbState());
    });
  }

  Future insertToDb({
    required String name,
    required String email,
    required String phone,
  }) async {
    return await db.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(name,email,phone,status) VALUES ("$name","$email","$phone","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDbState());
        getDataFromDb(db);
      }).catchError((error) {
        print('the error of insertion is ${error.toString()}');
      });
      return Future(() => null);
    });
  }

  List<Map> tasks = [];

  void getDataFromDb(db) {
    tasks = [];
    emit(AppLoadingState());
    db.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
          tasks.add(element);
      });
      emit(AppGetFromDbState());
    });
  }

  void updateDataFromDb({
    required String status,
    required int id,
  }) async {
    db.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDb(db);
      emit(AppUpdateDataFromDbState());
    });
  }

  void deleteDataFromDb({
    required int id
  }){
    db.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value) {
      getDataFromDb(db);
      emit(AppDeleteDataFromDbState());
    });
  }

  Future<void> synchronizeData(client , dataToSync) async {
    //final client = OdooClient('http://your-odoo-server-url.com');
    await client.authenticate('test_aymen', 'benkhaled_aymen@hotmail.fr', 'odoodbaymen');

    for (final data in dataToSync) {
      //final model = 'res.partner';
      //final recordId = data['id'];

      //if (recordId == null) {
        final result = await client.callKw({
          'model': 'res.partner',
          'method': 'create',
          'args': [
            {
              'name': data['name'],
              //'avatar_128' : 'http://146.59.159.198:4515/web/image?model=res.partner&field=avatar_128&id=7',
              'email': data['email'],
              'phone': data['phone']
            },
          ],
          'kwargs': {},
        });
        deleteDataFromDb(id: data['id']);
        print('insert doneeeeeeeeeeeeeeee $result');
        //if (result.isSuccess()) {
          //print(' Update the record ID in the local database');
          //final db = await database;
          //await db.update(table, {'id': result.getResult()}, where: 'name = ?', whereArgs: [data['name']]);
        //} else {
          //print('Failed to create record: ${result.getErrorMessage()}');
        //}
      // } else {
      //   final result = await client.callKw({
      //     'model': model,
      //     'method': 'write',
      //     'args': [
      //       [recordId],
      //       data,
      //     ],
      //     'kwargs': {},
      //   });
      //
      //   if (!result.isSuccess()) {
      //     print('Failed to update record: ${result.getErrorMessage()}');
      //   }
      // }
    }
    emit(AppSyncDataFromLocalDbState());
  }

}
