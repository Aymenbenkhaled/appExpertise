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

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCreateContactState) Navigator.pop(context);
      },
      builder: (context, state) {
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  {
                    if (cubit.bol) {
                      if (formKey.currentState!.validate()) {
                        cubit.createContact(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text);
                      }
                    } else {
                      scaffoldKey.currentState!
                          .showBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30))
                            ),
                            //backgroundColor: Colors.grey[300],
                            (context) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        defaultFormField(
                                          radius: 20,
                                          controller: nameController,
                                          type: TextInputType.text,
                                          label: 'Contact Name',
                                          prefIcon: Icons.person,
                                          validate: (value) {
                                            if (value!.isEmpty) {
                                              return 'Name empty';
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        defaultFormField(
                                          radius: 20,
                                          controller: emailController,
                                          type: TextInputType.text,
                                          label: 'Contact Email',
                                          prefIcon: Icons.email,
                                          validate: (value) {
                                            if (value!.isEmpty) {
                                              return 'Name empty';
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        defaultFormField(
                                          radius: 20,
                                          controller: phoneController,
                                          type: TextInputType.text,
                                          label: 'Contact Phone',
                                          prefIcon: Icons.phone,
                                          validate: (value) {
                                            if (value!.isEmpty) {
                                              return 'Name empty';
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                ),
                            ),
                          )
                          .closed
                          .then((value) {
                        cubit.ChangeBottomSheetState(
                            icon: Icons.edit, boll: false);
                      });
                      cubit.ChangeBottomSheetState(icon: Icons.add, boll: true);
                    }
                  }
                  ;
                },
                child: Icon(cubit.fabIcon),
              ),
              appBar: AppBar(
                title: Text('Contacts'),
              ),
              body: Center(
                child: FutureBuilder(
                    future: cubit.fetchContacts(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              final record =
                                  snapshot.data[index] as Map<String, dynamic>;
                              return buildListItem(record, context);
                            },
                            separatorBuilder: (context, index) =>
                                buildSeparator());
                      } else {
                        if (snapshot.hasError)
                          return Text('Unable to fetch data');
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            );
          },
        );
      },
    );
  }
}
