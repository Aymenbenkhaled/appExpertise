import 'package:app_expertise/modules/printable_data/printable_data.dart';
import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ContactScreen extends StatelessWidget {
  final Map<String, dynamic> record;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  ContactScreen(
    this.record,
  );
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return GestureDetector(
          onLongPress: () {
            scaffoldKey.currentState!.showBottomSheet(
              shape: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
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
                      SizedBox(
                        height: 10,
                      ),
                      defaultBotton(
                          function: () {
                            cubit.updateContact(
                                //   record,
                                // nameController.text,
                                // phoneController.text,
                                // emailController.text,
                                record: record,
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text);
                            Navigator.pop(context);
                          },
                          text: 'UPDATE'
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Scaffold(
            key: scaffoldKey,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${record['id']}'),
                  Text('${record['name']}'),
                  Text('${record['email']}'),
                  Text('${record['phone']}'),
                  //Text('${record['amount_untaxed_signed']}'),
                  SizedBox(
                    height: 50,
                  ),
                  defaultBotton(
                      function: (){
                        cubit.printDoc(record);
                      },
                      text: 'PRINT')

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
