import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginResultScreen extends StatelessWidget {
  final String email;
  final String password;
  final List liste;


  LoginResultScreen({
    required this.liste,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Contacts'),
          ),
          body: Center(
            child: FutureBuilder(
                future: cubit.fetchContacts(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final record =
                          snapshot.data[index] as Map<String, dynamic>;
                          return buildListItem(record);
                        });
                  } else {
                    if (snapshot.hasError) return Text('Unable to fetch data');
                    return CircularProgressIndicator();
                  }
                }),
          ),
        );
      },
    );


    //   Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       onPressed: (){
    //         Navigator.pop(context);
    //       },
    //       icon: Icon(
    //           Icons.arrow_back_ios_new
    //       ),
    //     ),
    //     title: Text(
    //       'Login Resluts',
    //     ),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           '$email',
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 25,
    //           ),
    //         ),
    //         Text(
    //           '$password',
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 25,
    //           ),
    //         ),
    //         Text(
    //           '$liste',
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 25,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
