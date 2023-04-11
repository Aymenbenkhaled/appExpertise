import 'package:app_expertise/layout/app_layout.dart';
import 'package:app_expertise/modules/login/login_screen.dart';
import 'package:app_expertise/shared/bloc_observer.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

final client = OdooClient('http://146.59.159.198:4515');

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  // await client.authenticate(
  //     'o15_sandbox_demo', 'benkhaled.aymen', 'P@\$\$w0rd@@ym3n');
  // final res = await client.callRPC('/web/session/modules', 'call', {});
  // print('Installed modules: \n' + res.toString());
  Bloc.observer = MyBlocObserver();
  runApp(MainApp(client));
}

class MainApp extends StatelessWidget {
  MainApp(OdooClient client);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
        ),
      ),
    );
  }
}
