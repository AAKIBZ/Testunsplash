import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/model.dart';
import 'utils/ProgressIndicator.dart';

/// class for longpress of image to show details of image
class LongPressImageDetails extends StatelessWidget {
  final UnsplashModel image;

  LongPressImageDetails(this.image);

  @override
  Widget build(BuildContext context) => /*Container*/ Card(
        margin: const EdgeInsets.only(top: 16.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0)),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: image != null
                ? <Widget>[
                    InkWell(
                      // onTap: () => launch(image?.user?.getHtmlLink()),
                      child: Column(children: [
                        Row(
                          children: <Widget>[
                            _buildUserProfileImage(image?.urls.small),
                            Text(
                              '${image.user.firstName} ${image?.user.lastName}',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                '${image.createdAt}'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            'the desc is : ${image.description}'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            'Likes : ${image.likes}'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                    ),
                    // show description
                    _buildDescriptionWidget(image.description),
                    // show location
                    // _buildLocationWidget(image.),
                    // show exif data
                    // _buildExifWidget(image.ex),
                    // filter null views
                  ].where((w) => w != null).toList()
                : <Widget>[ProgressIndicatorData(Colors.black26)]),
        /*decoration: new BoxDecoration(
            color: Colors.grey[50],
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),*/
      );

  /// Builds a round image widget displaying a profile image from a given [url].
  Widget _buildUserProfileImage(String url) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
      );

  /// Builds widget displaying a given [description] for an image.
  Widget _buildDescriptionWidget(String description) => description != null
      ? Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
          child: Text(
            '$description',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 16.0,
              letterSpacing: 0.1,
            ),
          ),
        )
      : null;

  /// Builds a widget displaying the [location], where the image was captured.
  Widget _buildLocationWidget(UnsplashModel location) => location != null
      ? Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black54,
                  )),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '${location.description}, ${location.createdAt}'
                        .toUpperCase(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        )
      : null;

  /// Builds a widget displaying all [exif] data
  Widget _buildExifWidget(UnsplashModel exif) => exif != null
      ? Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.photo_camera,
                    color: Colors.black54,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                      child: Text(
                        '${exif.promotedAt.toString()}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      )),
                  Row(
                    children: <Widget>[
                      // display exif info
                      _buildExifInfoItem('ƒ${exif.width}'),
                      _buildExifInfoItem('${exif.promotedAt}'),
                      _buildExifInfoItem('${exif.links}mm'),
                      _buildExifInfoItem('ISO${exif.description}'),
                    ],
                  ),
                ],
              )
            ].where((w) => w != null).toList(),
          ))
      : null;

  /// Builds exif info item that displays given [data].
  Widget _buildExifInfoItem(String data) => data != null
      ? Padding(
          padding:
              EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
          child: Text(
            data,
            style: TextStyle(
                color: Colors.black26,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
          ))
      : null;
}
