import 'package:app_expertise/shared/components/components.dart';
import 'package:app_expertise/shared/cubit/cubit.dart';
import 'package:app_expertise/shared/cubit/states.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Search',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: defaultFormField(
                  controller: textController,
                  type: TextInputType.text,
                  label: 'Search',
                  prefIcon: Icons.search,
                  radius: 20,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Search Must Not Be Empty';
                    }
                  },
                  onChange: (value) {
                    cubit.getSearch(value);
                  } ,
                ),
              ),
              Expanded(
                child: ConditionalBuilder(
                  condition: cubit.list.length>0,
                  builder: (BuildContext context) {
                    return  ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return buildListItem(cubit.list[index],context);
                      },
                      separatorBuilder: (BuildContext context, int index) => buildSeparator(),
                      itemCount: cubit.list.length,
                    );
                  },
                  fallback: (context) {
                    return Center(child: Text('No Data'));
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
