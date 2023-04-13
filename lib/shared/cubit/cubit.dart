import 'package:app_expertise/main.dart';
import 'package:bloc/bloc.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppInitialState(),);

  static AppCubit get(context) => BlocProvider.of(context);

  bool b = false;

  bool isVisible = true;

  void changeVisibility(){
    isVisible = !isVisible;
    emit(AppChangePswVisibilityState());
  }

  // final image_field =
  // session.serverVersionInt >= 13 ? 'image_128' : 'image_small';

  Future<dynamic> fetchContacts() async{
    return await client.callKw({
      'model': 'res.partner',
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

  var partner_id ;

  IconData fabIcon = Icons.edit;
  bool bol = false;

  void createContact(
  {
    required String name,
    required String email,
    required String phone,
}
      ) async{
   await client.callKw({
      'model': 'res.partner',
      'method': 'create',
      'args': [
        {
          'name': name,
          //'avatar_128' : 'http://146.59.159.198:4515/web/image?model=res.partner&field=avatar_128&id=7',
          'email' : email,
          'phone' : phone
        },
      ],
      'kwargs': {},
    }).then((value) {
     print('sayiiiiiiiiiiiiii');
     emit(AppCreateContactState());
     fetchContacts();
     emit(AppFetchContactState());
     partner_id = value;
   }
    ).catchError((er)=>print(er));
  }
void updateContact() async{
  await client.callKw({
    'model': 'res.partner',
    'method': 'write',
    'args': [
      'partner_id',
      {
        'is_company': true,
        'name' : 'Ben Aymen',
        'email' : 'Benkhaled_aymen@hotmail.fr',
        'phone' : '0667879845',
        //'image_1920' : 'assets/images/img.jpg'
      },
    ],
    'kwargs': {},
  }).then((value) {
    fetchContacts();
    emit(AppFetchContactState());
    print('contact updated');
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
}
