import 'package:app_expertise/main.dart';
import 'package:bloc/bloc.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool b = false;

  bool isVisible = true;

  void changeVisibility(){
    isVisible = !isVisible;
    emit(AppChangePswVisibility());
  }

  Future<dynamic> fetchContacts() {
    return client.callKw({
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name', 'email', '__last_update', 'image_128'],
        'limit': 80,
      },
    });
  }

}
