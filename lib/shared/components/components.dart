import 'package:app_expertise/main.dart';
import 'package:app_expertise/modules/contact/contact_screen.dart';
import 'package:app_expertise/modules/facturation/facturation_screen.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/local/cache_helper.dart';

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
    BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormField(
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
              gapPadding: 10,
            ),
          ),
        );
      },
    );

Widget defaultBotton({
  double width = 200,
  double? height,
  double radius = 30,
  double textSize = 30,
  //Color background = Colors.lightBlueAccent,
  bool isUpperCase = true,
  required Function function,
  required String text,
  Color color = Colors.white,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.deepOrange[900],
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
            fontSize: textSize,
            color: Colors.white,
          ),
        ),
      ),
    );

void navPush(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

void navPushAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (Route<dynamic> route) => false,
  );
}

Widget buildListItem(record, context) {
  var cubit = AppCubit.get(context);
  var unique = record['__last_update'] as String;
  String sess = CacheHelper.getData(key: 'sessionId');
  final headers = {
    'Cookie': 'session_id=$sess',
  };
  unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
  print(client.baseURL);
  print(unique);
  print(headers);
  print(record["id"]);
  final avatarUrl =
      '${client.baseURL}/web/image?model=res.partner&id=${record["id"]}&field=avatar_128&unique=$unique';
  print(record['avatar_128']);
  //print(cubit.image_field);

  return GestureDetector(
    onTap: () async {
      navPush(context, ContactScreen(record));
    },
    // onLongPress: () {
    //   cubit.updateContact(record);
    // },
    child: Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        print(record['id']);
        print(client.baseURL);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
                width: 80,
                height: 80,
                //child: CircleAvatar(backgroundImage: NetworkImage(avatarUrl,headers: headers),backgroundColor: Colors.transparent),
                child: Image.network(
                  avatarUrl,
                  headers: headers,
                ),
            ),
            //   CachedNetworkImage(
            //     httpHeaders: headers,
            //     imageUrl: avatarUrl,
            //     placeholder: (context, url) => const CircularProgressIndicator(),
            //     errorWidget: (context, url, error) {return const Icon(Icons.error);},
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${record['name']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${record['phone']}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  //   ListTile(
  //   leading: CircleAvatar(backgroundImage: AssetImage(avatarUrl)),
  //   title: Text(record['name']),
  //   subtitle: Text(record['email'] is String ? record['email'] : ''),
  // );
}

Widget buildListItemSql(record, context) {
  var cubit = AppCubit.get(context);
  return GestureDetector(
    onTap: () async {
      navPush(context, ContactScreen(record));
    },
    // onLongPress: () {
    //   cubit.updateContact(record);
    // },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
              width: 80,
              height: 80,
              //child: CircleAvatar(backgroundImage: NetworkImage(avatarUrl,headers: headers),backgroundColor: Colors.transparent),
              child: Image.asset(
                'assets/images/male.png',
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${record['name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${record['phone']}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  //   ListTile(
  //   leading: CircleAvatar(backgroundImage: AssetImage(avatarUrl)),
  //   title: Text(record['name']),
  //   subtitle: Text(record['email'] is String ? record['email'] : ''),
  // );
}

Widget buildContectItem() {
  return Row(
    children: [
      CircleAvatar(),
    ],
  );
}

Widget buildSeparator() {
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 20),
    child: Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey[500],
    ),
  );
}

class ImageBuilder extends StatelessWidget {
  const ImageBuilder({
    Key? key,
    required this.imagePath,
    this.imgWidth = 200,
    this.imgheight = 200,
  }) : super(key: key);

  final String imagePath;
  final double imgWidth;
  final double imgheight;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: imgWidth,
      height: imgheight,
    );
  }
}
