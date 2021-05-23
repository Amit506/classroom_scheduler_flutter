import 'package:cached_network_image/cached_network_image.dart';
import 'package:classroom_scheduler_flutter/Theme.dart/colors.dart';
import 'package:flutter/material.dart';

class CircularPeopleAvatar extends StatelessWidget {
  final String text;
  final String imageUrl;
  final double radius;

  const CircularPeopleAvatar({Key key, this.text, this.imageUrl, this.radius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        color: color12.withOpacity(0.4),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: imageUrl == null
          ? buildContainer()
          : Stack(
              fit: StackFit.expand,
              children: [
                buildCircleAvatar(imageUrl),
                Container(
                  decoration: BoxDecoration(
                    // color: color12.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
                // Center(child: Text(text))
              ],
            ),
    );
  }

  Widget buildContainer() {
    return Center(
      child: Text(text),
    );
  }

  Widget buildCircleAvatar(String url) {
    return CircleAvatar(
      backgroundColor: color12,
      backgroundImage: CachedNetworkImageProvider(url),
    );
  }
}
