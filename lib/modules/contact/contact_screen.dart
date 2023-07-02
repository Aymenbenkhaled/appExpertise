import 'package:app_expertise/modules/printable_data/printable_data.dart';
import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../main.dart';
import '../../shared/network/local/cache_helper.dart';

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
        var unique = record['__last_update'] as String;
        String sess = CacheHelper.getData(key: 'sessionId');
        final headers = {
          'Cookie': 'session_id=$sess',
        };
        unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
        final avatarUrl =
            '${client.baseURL}/web/image?model=res.partner&id=${record["id"]}&field=avatar_128&unique=$unique';
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
                      ElevatedButton(
                        onPressed: cubit.getImage,
                        child: Text('Choose Image'),
                      ),
                      cubit.image != null ? Image.file(cubit.image!) : Container(),
                      ElevatedButton(
                        onPressed: ()=>cubit.updateContactImage(record: record),
                        child: Text('Upload Data'),
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
                                email: emailController.text
                            );
                            Navigator.pop(context);
                            //cubit.fetchContacts();
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
                  Container(
                    height: 150,
                    width: 150,
                    child:  Image.network(
                      avatarUrl,
                      headers: headers,
                    ),
                    // CachedNetworkImage(
                    //   httpHeaders: headers,
                    //   imageUrl: avatarUrl,
                    //   fit: BoxFit.cover,
                    //   placeholder: (context, url) => const CircularProgressIndicator(),
                    //   errorWidget: (context, url, error) {return const Icon(Icons.error);},
                    // ),
                  ),
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
