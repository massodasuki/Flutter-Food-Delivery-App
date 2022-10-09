import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monkey_app_demo/const/colors.dart';
import 'package:monkey_app_demo/screens/dessertScreen.dart';
import 'package:monkey_app_demo/utils/helper.dart';
import 'package:monkey_app_demo/widgets/customNavBar.dart';
import 'package:monkey_app_demo/widgets/searchBar.dart';

import 'package:http/http.dart' as http;
import '../const/apiConstants.dart';
import '../model/machineModel.dart';

final storage = FlutterSecureStorage();

// A function that converts a response body into a List<Photo>.
List<Machine> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Machine>((json) => Machine.fromJson(json)).toList();
}
Future<String> _getListMachine() async {
  String bearerToken = await storage.read(key: "bearer-token");
  var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getVendingMachinesEnpoint);
  // log('url --> $url');
  final response = await http.get(
      Uri.parse(url.toString()),
  headers: <String, String>{
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

  var test = response.statusCode;
  log('response --> $test');

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    var test = response.body;
    log('response --> $test');

    // return 1;
    return response.body;

    // var list = (json.decode(response.body)['data'] as List)
    //     .map((data) => Machine.fromJson(data))
    //     .toList();

    // return parsePhotos(response.body);

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to get machines.');
  }
}


class MenuScreen extends StatefulWidget {
  static const routeName = "/menuScreen";

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<dynamic> machineList = [];

  Future<void> readJson() async {

    String bearerToken = await storage.read(key: "bearer-token");
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getVendingMachinesEnpoint);
    // log('url --> $url');
    final response = await http.get(
        Uri.parse(url.toString()),
        headers: <String, String>{
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
    // log('dataaaaaa is listtttttt --> $data');
    machineList = data['data']
        .map((data) => Machine.fromJson(data)).toList();
    // print(machineList);
    // log('listtttttt --> ${machineList[0]}');
    // // log('listtttttt --> ${machineList[0]['m_id']}');
    // log('listtttttt --> ${machineList[0].m_id}');
    // log('listtttttt --> ${machineList.length}');
    setState(() {
      machineList = data['data']
          .map((data) => Machine.fromJson(data)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readJson();
  }


  // getListMachines() async {
  //  var response = await  _getListMachine();
  //  this.count = response.length;
  //  var list = jsonEncode(response);
  //  log('initState $list');
  //  // log('initState ${response.length}');
  //  // log('initState ${response[0].getMLatitude}');
  //
  //  machines = (list as List)
  //       .map((data) => Machine.fromJson(data))
  //       .toList();
  //  // machines = parsePhotos(response);
  //   log('initState ${machines[0].getMLatitude}');
  //   return machines;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Vending Machine",
                        style: Helper.getTheme(context).headline5,
                      ),
                      Image.asset(
                        Helper.getAssetName("cart.png", "virtual"),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SearchBar(title: "Search Food"),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: Helper.getScreenHeight(context) * 0.6,
                    width: Helper.getScreenWidth(context),
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          width: 100,
                          decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              color: AppColor.orange),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children : List.generate(machineList.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(DessertScreen.routeName,
                                      // we are passing a value to the settings page
                                      arguments:  {'index': index});
                                  },
                                  child: MenuCard(
                                    imageShape: ClipPath(
                                      clipper: CustomTriangle(),
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        child: Image.network(machineList[index].m_picture, fit: BoxFit.cover,),
                                        // child: Image.asset(
                                        //   Helper.getAssetName(
                                        //       "dessert.jpg", "real"),
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                    ),
                                    name: "Desserts",
                                    count: "135",
                                    m_id: machineList[index].m_id,
                                    m_name: machineList[index].m_name,
                                    m_picture: "",
                                    m_latitude: machineList[index].m_latitude,
                                    m_longitude: machineList[index].m_longitude,
                                    m_desc: machineList[index].m_desc

                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBar(
              menu: true,
            ),
          )
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    Key key,
    @required String name,
    @required String count,
    String m_id,
    String m_name,
    String m_picture,
    String m_latitude,
    String m_longitude,
    String m_desc,
    @required Widget imageShape,
  })  : _name = name,
        _count = count,
        _m_id = m_id,
        _m_name = m_name,
        _m_picture = m_picture,
        _m_latitude = m_latitude,
        _m_longitude = m_longitude,
        _m_desc = m_desc,
        _imageShape = imageShape,
        super(key: key);

  final String _name;
  final String _count;
  final String _m_id;
  final String _m_name;
  final String _m_picture;
  final String _m_latitude;
  final String _m_longitude;
  final String _m_desc;
  final Widget _imageShape;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 80,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.placeholder,
                offset: Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _m_id,
                style: Helper.getTheme(context).headline4.copyWith(
                  color: AppColor.primary,
                ),
              ),
              SizedBox(
                height: 0.1,
              ),
              Text("$_m_name "),
              SizedBox(
                height: 0.1,
              ),
              Text("$_m_picture "),
              SizedBox(
                height: 0.1,
              ),
              Text("$_m_latitude "),
              SizedBox(
                height: 0.1,
              ),
              Text("$_m_longitude "),
              SizedBox(
                height: 0.1,
              ),
              Text("$_m_desc ")

            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _imageShape,
          ),
        ),
        SizedBox(
          height: 80,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 40,
              width: 40,
              decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      color: AppColor.placeholder,
                      offset: Offset(0, 2),
                      blurRadius: 5,
                    )
                  ]),
              child: Image.asset(
                Helper.getAssetName("next_filled.png", "virtual"),
              ),
            ),
          ),
        ),
    SizedBox(
    height: 90)],
    );
  }
}

class CustomTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Offset controlpoint = Offset(size.width * 0, size.height * 0.5);
    Offset endpoint = Offset(size.width * 0.2, size.height * 0.85);
    Offset controlpoint2 = Offset(size.width * 0.33, size.height);
    Offset endpoint2 = Offset(size.width * 0.6, size.height * 0.9);
    Offset controlpoint3 = Offset(size.width * 1.4, size.height * 0.5);
    Offset endpoint3 = Offset(size.width * 0.6, size.height * 0.1);
    Offset controlpoint4 = Offset(size.width * 0.33, size.height * 0);
    Offset endpoint4 = Offset(size.width * 0.2, size.height * 0.15);

    Path path = new Path()
      ..moveTo(size.width * 0.2, size.height * 0.15)
      ..quadraticBezierTo(
        controlpoint.dx,
        controlpoint.dy,
        endpoint.dx,
        endpoint.dy,
      )
      ..quadraticBezierTo(
        controlpoint2.dx,
        controlpoint2.dy,
        endpoint2.dx,
        endpoint2.dy,
      )
      ..quadraticBezierTo(
        controlpoint3.dx,
        controlpoint3.dy,
        endpoint3.dx,
        endpoint3.dy,
      )
      ..quadraticBezierTo(
        controlpoint4.dx,
        controlpoint4.dy,
        endpoint4.dx,
        endpoint4.dy,
      );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomDiamond extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.1000000, size.height * 0.4400000);
    path.quadraticBezierTo(size.width * 0.0243800, size.height * 0.5247000,
        size.width * 0.1000000, size.height * 0.6000000);
    path.quadraticBezierTo(size.width * 0.3550000, size.height * 0.8250000,
        size.width * 0.4400000, size.height * 0.9000000);
    path.quadraticBezierTo(size.width * 0.5140600, size.height * 0.9574800,
        size.width * 0.5800000, size.height * 0.9000000);
    path.quadraticBezierTo(size.width * 0.8200000, size.height * 0.6450000,
        size.width * 0.9000000, size.height * 0.5600000);
    path.quadraticBezierTo(size.width * 0.9500400, size.height * 0.5009400,
        size.width * 0.9000000, size.height * 0.4200000);
    path.quadraticBezierTo(size.width * 0.6450000, size.height * 0.1800000,
        size.width * 0.5600000, size.height * 0.1000000);
    path.quadraticBezierTo(size.width * 0.5029400, size.height * 0.0446800,
        size.width * 0.4200000, size.height * 0.1000000);
    path.quadraticBezierTo(size.width * 0.3400000, size.height * 0.1850000,
        size.width * 0.1000000, size.height * 0.4400000);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
