import 'package:app_expertise/layout/app_layout.dart';
import 'package:app_expertise/modules/login/login_screen.dart';
import 'package:app_expertise/shared/bloc_observer.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
        ),
      ),
    );
  }
}
