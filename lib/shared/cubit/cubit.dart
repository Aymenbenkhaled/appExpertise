import 'package:bloc/bloc.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isVisible = true;

  void changeVisibility(){
    isVisible = !isVisible;
    emit(AppChangePswVisibility());
  }

}
