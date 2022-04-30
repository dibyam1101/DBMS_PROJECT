import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../../cache/ids.dart';
import '../bloc/homepage_bloc.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  void initState() {
    var box = Hive.box<Id>("restaurantIds");
    BlocProvider.of<HomepageBloc>(context).add(Menu());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Customer Home Page'),
        ),
        body: Column(
          children: [
            Container(
              height: 150,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Center(
                        child: Text('Restaurant $index'),
                      ),
                    );
                  }),
            ),
            BlocBuilder<HomepageBloc, HomepageState>(
              builder: (context, state) {
                if (state is MenuLoaded) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: state.menu.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.amber,
                              title: Text(state.menu[index].itemName),
                              subtitle: Text(state.menu[index].restaurantId
                                  .substring(0, 4)),
                            ),
                          );
                        }),
                  );
                } else if (state is Loading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: Text("Some Error Occured"));
                }
              },
            )
          ],
        ));
  }
}
