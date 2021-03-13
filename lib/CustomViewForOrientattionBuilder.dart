import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_demo_nova/info_sheet.dart';
import 'package:unsplash_demo_nova/models/model.dart';
import 'package:url_launcher/url_launcher.dart';

/// ImageTile displayed in StaggeredGridView.
class CustomViewForOrientationBuilder extends StatelessWidget {
  final UnsplashModel image;

  const CustomViewForOrientationBuilder(this.image);
     /// adds some style
  Widget _addRoundedCorners(Widget widget) =>
      // wrap in ClipRRect to achieve rounded corners
      ClipRRect(borderRadius: BorderRadius.circular(12), child: widget);

  /// Returns a placeholder to show until an image is loaded.
  Widget _buildImagePlaceholder({UnsplashModel image}) => Container(
        color: image != null
            ? Color(int.parse(image.color.substring(1, 7), radix: 16) +
                0x64000000)
            : Colors.grey[300],
      );

  /// Returns a git placeholder to show until an image is loaded.
  Widget _buildImageErrorWidget() => Container(
      color: Colors.grey[200],
      child: Center(child: Icon(Icons.broken_image, color: Colors.grey[400])));

  @override
  Widget build(BuildContext context) => InkWell(
        onLongPress: () {
          Navigator.of(context).push(
            MaterialPageRoute<Null>(
                builder: (BuildContext context) =>
                LongPressImageDetails(image)
                ),
          );
        },
        onTap: () {
          launch(image?.links?.html);
        },
        child: image != null
            ? Hero(
                tag: '${image.id}',
                child: _addRoundedCorners(
                  CachedNetworkImage(
                    imageUrl: image?.urls?.thumb,
                    placeholder: (context, url) =>
                        _buildImagePlaceholder(),
                    errorWidget: (context, url, obj) =>
                        _buildImageErrorWidget(),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : _buildImagePlaceholder(),
      );
}
