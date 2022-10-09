import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/customNavBar.dart';
import 'package:monkey_app_demo/widgets/searchBar.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import '../const/apiConstants.dart';
import '../model/itemModel.dart';

final storage = FlutterSecureStorage();

class DessertScreen extends StatefulWidget {
  static const routeName = '/dessertScreen';
  final Map<String, dynamic> args;

  const DessertScreen(this.args, {Key key}) : super(key: key);

  @override
  State<DessertScreen> createState() => _DessertScreenState();
}

class _DessertScreenState extends State<DessertScreen> {
  List<dynamic> itemList = [];

  Future<void> readJson(int index) async {
    String id = index.toString();
    String bearerToken = await storage.read(key: "bearer-token");
    var url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.getVendingMachinesEnpoint +
        '/' +
        id);
    log('url --> $url');
    final response =
        await http.get(Uri.parse(url.toString()), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $bearerToken',
    }
            // ,
            // body: jsonEncode(<String, String>{
            //   'email': email,
            //   'password': password,
            //   'name': 'developer'
            // }),
            );

    final data = await json.decode(response.body);
    log('dataaaaaa is listtttttt --> $data');
    itemList = data['data'].map((data) => Item.fromJson(data)).toList();
    setState(() {
      itemList = data['data'].map((data) => Item.fromJson(data)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    readJson(widget.args["index"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: AppColor.primary,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "Menu List",
                                style: Helper.getTheme(context).headline5,
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          Helper.getAssetName("cart.png", "virtual"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SearchBar(
                    title: "Search Food",
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  // children: List.generate(machineList.length, (index) {
                  //   return GestureDetector(
                  //     onTap: () {
                  //       Navigator.of(context)
                  //           .pushNamed(DessertScreen.routeName,
                  //           // we are passing a value to the settings page
                  //           arguments:  {'index': index});
                  //     },
                  //
                  //     ),
                  //   );
                  // }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(itemList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    DessertScreen.routeName,
                                    // we are passing a value to the settings page
                                    arguments: {'index': index});
                              },
                              child: DessertCard(
                                // image: Image.asset(
                                //   Helper.getAssetName("apple_pie.jpg", "real"),
                                //   fit: BoxFit.cover,
                                // ),
                                image: Image.network(itemList[index].i_picture, fit: BoxFit.cover,),
                                name: "",
                                shop: "",
                                rating: "4.9",
                                i_name: itemList[index].i_name ,
                                i_desc: itemList[index].i_desc ,
                                i_price: itemList[index].i_price ,
                                i_status: itemList[index].i_status ,
                              ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // ),
                  // DessertCard(
                  //   image: Image.asset(
                  //     Helper.getAssetName("dessert2.jpg", "real"),
                  //     fit: BoxFit.cover,
                  //   ),
                  //   name: "Dark Chocolate Cake",
                  //   shop: "Cakes by Tella",
                  //   rating: "4.7",
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // DessertCard(
                  //   image: Image.asset(
                  //     Helper.getAssetName("dessert4.jpg", "real"),
                  //     fit: BoxFit.cover,
                  //   ),
                  //   name: "Street Shake",
                  //   shop: "Cafe Racer",
                  //   rating: "4.9",
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // DessertCard(
                  //   image: Image.asset(
                  //     Helper.getAssetName("dessert5.jpg", "real"),
                  //     fit: BoxFit.cover,
                  //   ),
                  //   name: "Fudgy Chewy Brownies",
                  //   shop: "Minute by tuk tuk",
                  //   rating: "4.9",
                  // ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBar(
              menu: true,
            ),
          ),
        ],
      ),
    );
  }
}

class DessertCard extends StatelessWidget {
  const DessertCard({
    Key key,
    @required String name,
    @required String rating,
    @required String shop,
    @required Image image,
    String i_name,
    String i_desc,
    String i_price,
    String i_status,


  })  : _name = name,
        _rating = rating,
        _shop = shop,
        _i_name = i_name,
        _i_desc = i_desc,
        _i_price = i_price,
        _i_status = i_status,
        _image = image,
        super(key: key);

  final String _name;
  final String _rating;
  final String _shop;
  final String _i_name;
  final String _i_desc;
  final String _i_price;
  final String _i_status;

  final Image _image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: _image,
          ),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: Helper.getTheme(context).headline4.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        Helper.getAssetName("star_filled.png", "virtual"),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _rating,
                        style: TextStyle(color: AppColor.orange),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _shop,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _i_name,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "RM " + _i_price,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _i_desc,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),

                      Text(
                        _i_status,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          ".",
                          style: TextStyle(color: AppColor.orange),
                        ),
                      ),
                      SizedBox(
                        width: 97,
                      ),
                      Text(
                        "Desserts",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
