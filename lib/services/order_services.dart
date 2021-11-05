import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_delivery_app/services/firebase_services.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServices {
  FirebaseServices _services = FirebaseServices();

  Color statusColor(document) {
    if (document.data()['orderStatus'] == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document.data()['orderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Colors.pink[900];
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Colors.deepPurpleAccent;
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon statusIcon(document) {
    if (document.data()['orderStatus'] == 'Accepted') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Icon(
        Icons.cases,
        color: statusColor(document),
      );
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
      );
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Icon(
        Icons.shopping_bag_outlined,
        color: statusColor(document),
      );
    }
    return Icon(
      Icons.assignment_turned_in_outlined,
      color: statusColor(document),
    );
  }

  Widget statusContainer(document, context) {
    FirebaseServices _services = FirebaseServices();

    if (document.data()['deliveryBoy']['name'].length > 1) {
      if (document.data()['orderStatus'] == 'Accepted') {
        return Container(
          color: Colors.grey[300],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              40,
              8,
              40,
              8,
            ),
            child: FlatButton(
              color: statusColor(document),
              child: Text(
                'Update Staatus to Picked Up',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: document.id, status: 'Picked Up')
                    .then((value) {
                  EasyLoading.showSuccess('Order is now Picked Up');
                });
              },
            ),
          ),
        );
      }
    }

    if (document.data()['orderStatus'] == 'Picked Up') {
      return Container(
        color: Colors.grey[300],
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            40,
            8,
            40,
            8,
          ),
          child: FlatButton(
            color: statusColor(document),
            child: Text(
              'Update Staatus to On the way',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              EasyLoading.show();
              _services
                  .updateStatus(id: document.id, status: 'On the way')
                  .then((value) {
                EasyLoading.showSuccess('Order is now On the way');
              });
            },
          ),
        ),
      );
    }

    if (document.data()['orderStatus'] == 'On the way') {
      return Container(
        color: Colors.grey[300],
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            40,
            8,
            40,
            8,
          ),
          child: FlatButton(
            color: statusColor(document),
            child: Text(
              'Deliver Order',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              if (document.data()['cod'] == true) {
                return showMyDialog(
                    'Receive Payment', 'Delivered', document.id, context);
              } else {
                EasyLoading.show();
                _services
                    .updateStatus(id: document.id, status: 'Delivered')
                    .then((value) {
                  EasyLoading.showSuccess('Order is now Delivered');
                });
              }
            },
          ),
        ),
      );
    }

    return Container(
      color: Colors.grey[300],
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        color: Colors.green,
        child: Text(
          'Order Completed',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  showMyDialog(title, status, documentId, context) {
    OrderServices _orderServices = OrderServices();
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text('Make sure you have received payment'),
          actions: [
            FlatButton(
              child: Text(
                'RECEIVED',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: documentId, status: 'Delivered')
                    .then((value) {
                  EasyLoading.showSuccess('Order is now Delivered');
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void launchCall(number) async {
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }

  void launcchMap(lat, long, name) async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: Coords(
        lat,
        long,
      ),
      title: name,
    );
  }
}
