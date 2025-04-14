import 'package:flutter/material.dart';
import 'Navigate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import './ApplicationFormPage.dart';
import './AppFormBuilder.dart';
import '/theme/AppTheme.dart';
import 'package:flutter_learning/pages/index.dart';
import '../components/dialog/confirm_dialog.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  //List<String> items = ["Application Form", "Setting", "Menu","Form Builder",'Modal'];

  List<dynamic> items = [
    {
      "name": "Test Page",
      "content": TestPage(),
    },
    {
      "name": "Application Form",
      "content": ApplicationFormPage(),
    },
    {
      "name": "Database",
      "content": DatabasePage(),
    },
    {
      "name": "Setting",
      "content": ApplicationFormPage(),
    },
    {
      "name": "Menu",
      "content": ApplicationFormPage(),
    },
    {
      "name": "Form Builder",
      "content": AppFormBuilder(),
    },
    {
      "name": "Modal",
      "content": ModalPage(),
    },
    {
      "name": "Dialog",
      "content": AppFormBuilder(),
    },
    {
      "name": "Prop",
      "content": PropTestPage(),
    },
  ];

  double itemGap = 5.0;
  double hPadding = 30.0;
  double vPadding = 10.0;

  void showBottomSheet() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Edit'),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Copy'),
            leading: Icon(Icons.content_copy),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Cut'),
            leading: Icon(Icons.content_cut),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Move'),
            leading: Icon(Icons.folder_open),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Edit'),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Copy'),
            leading: Icon(Icons.content_copy),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Cut'),
            leading: Icon(Icons.content_cut),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Move'),
            leading: Icon(Icons.folder_open),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void navigateToNewPage(index) {
    //if (items[index]["name"] == "Modal") showBottomSheet();
    if (items[index]["name"] == "Dialog") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog();

            return AlertDialog(
              title: Text("Dialog"),
              content: Text("This is a dialog"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                )
              ],
            );
          });
    } else
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                // Replace Navigrate with the desired destination page
                items[index]["content"]),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).appBar,
        title: Text(widget.title),
      ),
      body: ListView.separated(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(hPadding, index == 0 ? vPadding * 2 : vPadding, hPadding, vPadding),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue,
                textStyle: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                navigateToNewPage(index);
              },
              child: Text(items[index]["name"]),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container();
        },
      ),
    );
  }
}
