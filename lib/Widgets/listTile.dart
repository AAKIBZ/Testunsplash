
  import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_demo_nova/models/model.dart';

class ListTileForList{

    static Widget listTile(List<UnsplashModel> urls,int index){
      return Stack(
        children:[
          Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.grey)),
          child: Hero(
            tag: 'data',
            child: CachedNetworkImage(
              imageUrl: urls[index].urls.small,
              placeholder: (context, url) =>_buildImagePlaceholder(),
              errorWidget: (context, url, obj) => Icon(Icons.broken_image),
            ),
          ),)],
      );
    }

    /// Returns a placeholder to show until an image is loaded.
   static Widget _buildImagePlaceholder({UnsplashModel image}) => Container(
      color: image != null
          ? Color(int.parse(image.color.substring(1, 7), radix: 16) +
          0x64000000)
          : Colors.grey[300],
    );
  }