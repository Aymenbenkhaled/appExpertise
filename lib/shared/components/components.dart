import 'package:app_expertise/main.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  double radius = 0,
  required IconData prefIcon,
  IconData? suffIcon,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  Function()? onTap,
  required String? Function(String?)? validate,
  bool obscureText = false,
  Function()? suffpressd,
  //required String text,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      obscureText: obscureText,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefIcon,
        ),
        suffixIcon: IconButton(
          onPressed: suffpressd,
          icon: Icon(
            suffIcon,
          ),
        ),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );

Widget defaultBotton({
  double width = 200,
  double radius = 30,
  Color background = Colors.lightBlueAccent,
  bool isUpperCase = true,
  required Function function,
  required String text,
  Color color = Colors.white,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        //(){print('${emailController.text} //// ${passwordController.text} ' );},
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
    );

void navPush(context, widget){
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      )
  );
}

Widget buildListItem(Map<String, dynamic> record) {
  var unique = record['__last_update'] as String;
  unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
  final avatarUrl =
      '${client.baseURL}/web/image?model=res.partner&field=image_128&id=${record["id"]}&unique=$unique';
  return ListTile(
    leading: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
    title: Text(record['name']),
    subtitle: Text(record['email'] is String ? record['email'] : ''),
  );
}