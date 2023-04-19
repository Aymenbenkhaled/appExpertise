import 'package:app_expertise/layout/app_layout.dart';
import 'package:app_expertise/modules/login/login_screen.dart';
import 'package:app_expertise/shared/bloc_observer.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:odoo_rpc/odoo_rpc.dart';


void sessionChanged(OdooSession sessionId) async {
  print('We got new session ID: ' + sessionId.id);
  // write to persistent storage
}

void loginStateChanged(OdooLoginEvent event) async {
  if (event == OdooLoginEvent.loggedIn) {
    print('Logged in');
  }
  if (event == OdooLoginEvent.loggedOut) {
    print('Logged out');
  }
}

void inRequestChanged(bool event) async {
  if (event) print('Request is executing'); // draw progress indicator
  if (!event) print('Request is finished'); // hide progress indicator
}

final client = OdooClient('http://146.59.159.198:4515');
var subscription = client.sessionStream.listen(sessionChanged);
var loginSubscription = client.loginStream.listen(loginStateChanged);
var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

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
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              appBarTheme: AppBarTheme(
                titleSpacing: 20,
                color: Colors.white,
                elevation: 0,
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(color: Colors.black),
                //backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  //systemNavigationBarColor: Colors.white
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepOrange,
              ),
              scaffoldBackgroundColor: Colors.white,
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.deepOrange,
              appBarTheme: AppBarTheme(
                titleSpacing: 20,
                color: HexColor('333739'),
                elevation: 0,
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(color: Colors.white),
                //backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: HexColor('333739'),
                  statusBarIconBrightness: Brightness.light,
                  //systemNavigationBarColor: Colors.white
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.deepOrange,
                  elevation: 20,
                  backgroundColor: HexColor('333739'),
                  unselectedItemColor: Colors.grey[400]
              ),
              scaffoldBackgroundColor: HexColor('333739'),
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis),
              ),
              //hintColor: Colors.white,
              inputDecorationTheme: InputDecorationTheme(
                fillColor: Colors.grey[500],
                filled: true
              ),
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.grey[600],

              ),
            ),
            themeMode: cubit.darkLight == true ? ThemeMode.dark : ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          );
        }
      ),
    );
  }
}
