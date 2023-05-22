import 'package:app_expertise/modules/printable_data/printable_data.dart';
import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class FacturationScreen extends StatelessWidget {
  final Map<String, dynamic> record;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  FacturationScreen(
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
                            cubit.fetchContacts();
                          },
                          text: 'UPDATE'),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Scaffold(
            key: scaffoldKey,
            body: Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Facture client',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      '${record['name']}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child:
                            Row(
                                children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Client',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Référence du paiement',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Date de facturation',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Date d\'échéance',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      'Devise',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                                child: Container(
                                  width: 2,
                                  height: double.infinity,
                                  color: Colors.grey[500],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${record['invoice_partner_display_name']}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      '${record['name']}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${record['invoice_date']}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${record['invoice_payment_term_id']}',
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${record['currency_id']}',
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Expanded(
                            child:
                            Row(
                                children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Montant HT	:',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Taxes :',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Total :',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Montant dû :',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${record['tax_totals_json']}',
                                      maxLines: 10,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 20,),
                                    Text(
                                      '${record['name']}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '${record['invoice_date']}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      '${record['amount_residual']}',
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),

                        ],
                      ),
                    ),
                    // Text('${record['id']}'),
                    // Text('${record['name']}'),
                    // Text('${record['invoice_partner_display_name']}'),
                    // Text('${record['amount_total_signed']} DA'),
                    //Text('${record['amount_untaxed_signed']}'),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: defaultBotton(
                          function: () {
                            cubit.printFacDoc(record);
                          },
                          text: 'PRINT'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
