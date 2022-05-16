import 'package:flutter/material.dart';
import 'package:imin/helpers/configs.dart';

class ImageProfile extends StatefulWidget {
  const ImageProfile({Key? key}) : super(key: key);

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  @override
  Widget build(BuildContext context) {
    // return Image.network(
    //   'https://images.unsplash.com/photo-1547721064-da6cfb341d50',
    //   width: 280.0,
    // );

    return Image.network(
      ipServer + '/guard/profile_image/guard_profile.jpg',
    );
  }
}