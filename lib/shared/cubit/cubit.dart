import 'dart:io';

import 'package:app_expertise/main.dart';
import 'package:app_expertise/modules/printable_data/printable_data.dart';
import 'package:bloc/bloc.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

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

  // final image_field =
  // session.serverVersionInt >= 13 ? 'image_128' : 'image_small';

  Future<dynamic> fetchContacts() async {
    return await client.callKw({
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name', 'email', 'phone', '__last_update', 'image_1920'],
        'limit': 80,
      },
    });
  }
  Future<dynamic> fetchFacturation() async {
    return await client.callKw({
      'model': 'account.move',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name', 'email', '__last_update', 'avatar_128'],
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
      fetchContacts();
      emit(AppFetchContactState());

      partner_id = value;
    }).catchError((er) => print(er));
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
          'name' : '$namee',
          'phone' : '$phonee',
          'email' : '$emaill',
          //'image_1920' : 'assets/images/img.jpg'
        },
      ],
      'kwargs': {},
    }).then((value) {
      emit(AppUpdateContactState());
      print('contact updated');
      fetchContacts();
      emit(AppFetchContactState());
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
                pw.Image(
                  image,
                  width: 200,
                  height: 200
                ),
                pw.Text(
                  '${record['id']}',
                  style: pw.TextStyle(
                    fontSize: 30
                  )
                ),
                pw.Text(
                    '${record['name']}',
                    style: pw.TextStyle(
                        fontSize: 30
                    )
                ),
                pw.Text(
                    '${record['email']}',
                    style: pw.TextStyle(
                        fontSize: 30
                    )
                ),
                pw.Text(
                    '${record['phone']}',
                    style: pw.TextStyle(
                        fontSize: 30
                    )
                ),
                pw.SizedBox(height: 50,),
              ],
            ),
          );
        })
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }


}


