  import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DEMO extends StatefulWidget {
    @override
    _DEMOState createState() => _DEMOState();
  }

  class _DEMOState extends State<DEMO> {
  SharedPreferences prefs;
  List<String> imgList=List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getPrefs();
    });
  }

  getPrefs() async{
    prefs = await SharedPreferences.getInstance();
    imgList=prefs.getStringList("imageList");
    print('AAKIB'+prefs.getStringList("imageList").toString());
  }
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home:ListView.builder
          (
          itemCount: imgList.length,
          itemBuilder: (BuildContext ctxt, int index) {
        return  CachedNetworkImage(
             imageUrl: imgList[index],
        );
      }
      )
      );
    }
  }
