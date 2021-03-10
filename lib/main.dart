import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_demo_nova/models/MianModel.dart';
import 'package:unsplash_demo_nova/services/unsplashImageProvider.dart';
import 'CustomViewForOrientattionBuilder.dart';
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
        splashColor: Colors.blue,
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int page = 0, totalPages = -1;
  List<UnsplashImageModel> images = [];
  bool loadingImages = false;

  @override
  initState() {
    super.initState();
    _loadImages();
  }

  /// Requests a list of Images.
  _loadImages() async {
    if (loadingImages) {
      return;
    }
    if (totalPages != -1 && page >= totalPages) {
      return;
    }
    await Future.delayed(Duration(microseconds: 1));
    setState(() {
      checkInternetConnection(context);
      loadingImages = true;
    });

    List<UnsplashImageModel> images;
    images = await UnsplashImageProvider.loadImages(page: ++page);
    // update the state
    setState(() {
      loadingImages = false;
      this.images.addAll(images);
    });
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
                              child: ProgressIndicatorData(Colors.grey[400]))
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
        itemCount: images.length,
        // set itemBuilder
        itemBuilder: (BuildContext context, int index) =>
            _buildImageItemBuilder(index),
        staggeredTileBuilder: (int index) =>
            _buildStaggeredTile(images[index], columnCount),
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
  Future<UnsplashImageModel> _loadImage(int index) async {
    // check if new images need to be loaded
    if (index >= images.length - 2) {
      // Reached the end of the list. Try to load more images.
      _loadImages();
    }
    return index < images.length ? images[index] : null;
  }

  /// Returns a StaggeredTile for a given image.
  StaggeredTile _buildStaggeredTile(UnsplashImageModel image, int columnCount) {
    double aspectRatio =
        image.getHeight().toDouble() / image.getWidth().toDouble();
    double columnWidth = MediaQuery.of(context).size.width / columnCount;
    // not using [StaggeredTile.fit(1)] because during loading StaggeredGrid is really jumpy.
    return StaggeredTile.extent(1, aspectRatio * columnWidth);
  }

  /// used for swipe refresh layout to load latest images from the api..
  Future onRefresh() async {
    setState(() {
      images.clear();
    });
    Future.delayed(Duration(
      seconds: 2,
    ));
    _loadImages();
  }
}

/// checks whether there is internet or not
void checkInternetConnection(BuildContext context) async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      final snackBar =
          SnackBar(content: Text('internet Connected we are good to go...'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar =
          SnackBar(content: Text('internet chuy band yali traw jaldii'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } on SocketException catch (_) {
    final snackBar = SnackBar(content: Text('No Internet Connection'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print('not connected');
  }
}
