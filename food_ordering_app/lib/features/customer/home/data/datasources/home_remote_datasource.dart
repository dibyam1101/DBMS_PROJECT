import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:food_ordering_app/core/error/exceptions.dart';

import '../../../../../cache/restaurantIds.dart';
import '../models/menuitem_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<MenuItemModel>> getMenuR(String restaurantId);
  Future<List<MenuItemModel>> getMenu(String category);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<MenuItemModel>> getMenuR(String restaurantId) async {
    List<MenuItemModel> orders = [];
    try {
      await FirebaseFirestore.instance
          .collection("restaurants")
          .doc(restaurantId)
          .collection("menu")
          .get()
          .then((value) {
        print(value.docs.length);
        value.docs.forEach((element) {
          orders.add(MenuItemModel.fromJson(element.data(), restaurantId));
        });
      });
      return orders;
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<List<MenuItemModel>> getMenu(String category) async {
    List<MenuItemModel> orders = [];

    List<String> restaurantIds = getRestaurantIds();
    try {
      for (var element in restaurantIds) {
        await FirebaseFirestore.instance
            .collection("restaurants")
            .doc(element)
            .collection("menu")
            .get()
            .then((value) {
          value.docs.forEach((element1) {
            // ?? Here I have omitted the condition for category
            // ?? This will return all the items of all the restaurants
            if (element1.data().isNotEmpty) {
              orders.add(MenuItemModel.fromJson(element1.data(), element));
            }
          });
        });
      }
      return orders;
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }
}