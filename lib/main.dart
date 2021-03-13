import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_demo_nova/models/model.dart';
import 'package:unsplash_demo_nova/services/unsplashImageProvider.dart';

import 'CustomViewForOrientattionBuilder.dart';
import 'checkinternet.dart';
import 'utils/ProgressIndicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AAKIB',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  ///dynamically detect the state of the internet
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int page = 0, totalPages = -1;
  List<UnsplashModel> images1 = [];
  bool loadingImages = false;

  // SharedPreferences preferences;
  bool isInternet = true;
  List<String> imgs = [];

  @override
  initState() {
    super.initState();
    _loadImages();
    // _getValue();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      onRefresh();
    });
  }
  /// Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initConnectivity() async {
  //   ConnectivityResult result = ConnectivityResult.none;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //   return _updateConnectionStatus(result);
  // }
  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //       ToastClass.showToast("Connected To wifi ");
  //       break;
  //     case ConnectivityResult.mobile:
  //       ToastClass.showToast("Connected To Mobile Data");
  //       break;
  //     case ConnectivityResult.none:
  //       ToastClass.showToast("oops! we detected no internet");
  //       setState(() => _connectionStatus = result.toString());
  //       break;
  //     default:
  //       setState(() => _connectionStatus = 'Failed to get connectivity.');
  //       break;
  //   }
  // }

  /// Requests a list of Images.
  _loadImages() async {
    setState(() {
      CheckInternet().checkInternetConnection(context);
    });
     images1 = await UnsplashImageProvider.getImagesFromUnsplash(context);

    // update the state
    if (images1.isNotEmpty) {
      loadingImages = true;
      setState(() {
      });
    } else {
      print('aakib there is null value in the list ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('awesome photos'),
        ),
        backgroundColor: Colors.grey[50],
        body: Stack(
          children: [
            /// the cached image network provided by flutter works well for a single url means we can cache single urls successfully but the list we cant have dynamic urls when net is of so we have save them either in file or in local database like sqlflite provided by flutter
            // CachedNetworkImage(imageUrl:"https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80" )
            RefreshIndicator(
                key: _refreshIndicatorKey,
                child: OrientationBuilder(
                  builder: (context, orientation) => CustomScrollView(
                    slivers: <Widget>[
                      _buildImageGrid(orientation: orientation),
                      loadingImages
                          ? SliverToBoxAdapter(
                              child: Center(
                                  child:
                                      ProgressIndicatorData(Colors.grey[400])))
                          : _buildImageGrid(orientation: orientation),
                    ].where((w) => w != null).toList(),
                  ),
                ),
                onRefresh: onRefresh),
          ],
        )
        // ),
        );
  }

  /// Returns the grid that displays images actually according to requirement we have to display only orientation is used if we use landscape mode.
  Widget _buildImageGrid({orientation = Orientation.portrait}) {
    // calc columnCount based on orientation
    int columnCount = orientation == Orientation.portrait ? 1 : 2;
    // return staggered grid
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverStaggeredGrid.countBuilder(
        // set column count
        crossAxisCount: columnCount,
        itemCount: images1.length,
        // set itemBuilder
        itemBuilder: (BuildContext context, int index) =>
           images1.isEmpty?CircularProgressIndicator():
            _buildImageItemBuilder(index),
        staggeredTileBuilder: (int index) =>
            _buildStaggeredTile(images1[index], columnCount),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
    );
  }

  /// Returns a FutureBuilder to load a Image for a given [index].
  Widget _buildImageItemBuilder(int index) => FutureBuilder(
        // pass image loader
        future: _loadImage(index),
        builder: (context, snapshot) =>
            CustomViewForOrientationBuilder(snapshot.data),
      );

  /// Asynchronously loads a Image for a given index.
  Future<UnsplashModel> _loadImage(int index) async {
    // check if new images need to be loaded
    if (index >= images1.length - 2) {
      // Reached the end of the list. Try to load more images.
      _loadImages();
    }
    return index < images1.length ? images1[index] : null;
  }

  /// Returns a StaggeredTile for a given image.
  StaggeredTile _buildStaggeredTile(UnsplashModel image, int columnCount) {
    double aspectRatio = image.height.toDouble() / image.width.toDouble();
    double columnWidth = MediaQuery.of(context).size.width / columnCount;
    // not using [StaggeredTile.fit(1)] because during loading StaggeredGrid is really jumpy.
    return StaggeredTile.extent(1, aspectRatio * columnWidth);
  }

  /// used for swipe refresh layout to load latest images from the api..
  Future onRefresh() async {
    // setState(() {
    //   // images1.clear();
    // });
    images1.clear();
    _loadImages();
  }

  ///used for local cache
// setImageInCache() async {
//   preferences = await SharedPreferences.getInstance();
//   print("Image URLS    " + images.length.toString());
//   for (int i = 0; i < images.length; i++) {
//     imgs.add(images[i].getSmallUrl());
//     print('CACHE RESULTS' + images[i].getSmallUrl());
//   }
//   preferences.setStringList("imageList", imgs);
//   print('CACHE RESULTS AFTER SAVE' + imgs.toString());
// }



}
