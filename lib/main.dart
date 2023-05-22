import 'package:app_expertise/layout/app_layout.dart';
import 'package:app_expertise/modules/login/login_screen.dart';
import 'package:app_expertise/modules/login_result/login_result_screen.dart';
import 'package:app_expertise/shared/bloc_observer.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:app_expertise/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:odoo_rpc/odoo_rpc.dart';


void sessionChanged(OdooSession sessionId) async {
  print('We got new session ID: ' + sessionId.id);
  await SessionManager().set('session', sessionId);
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


dynamic sessionn = SessionManager().get("session");
final client = OdooClient('https://de79-154-121-41-29.ngrok-free.app');

var subscription = client.sessionStream.listen(sessionChanged);
var loginSubscription = client.loginStream.listen(loginStateChanged);
var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool isLogin = CacheHelper.getData(key: 'isLogin');
  //print(isLogin);
  runApp(MainApp(client,isLogin));
}

class MainApp extends StatelessWidget {
  final bool isLogin;
  MainApp(OdooClient client,this.isLogin);

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
            themeMode: cubit.darkLight == true ? ThemeMode.light : ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            home: isLogin ? LoginResultScreen() : LoginScreen(),
          );
        }
      ),
    );
  }
}
