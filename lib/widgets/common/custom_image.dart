import 'dart:io';

import 'package:flutter_base/core/common_imports.dart';

class CustomImage extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final File? file;
  final String? url;
  final int type; // 1 for asset; 2 for file; 3 for network
  const CustomImage(
    this.path, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.colorBlendMode,
    this.fit = BoxFit.cover,
    this.type = 1,
    this.file,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    try {
      if ((url == null || url == "null" || url == "") && type == 3) {
        return Image.asset(
          path,
          height: height,
          width: width,
          fit: fit,
          color: color,
          colorBlendMode: BlendMode.srcATop,
        );
      }
      // if (path.endsWith(".svg")) {
      //   return SvgPicture.asset(
      //     path,
      //     height: height,
      //     width: width,
      //     fit: fit,
      //     color: color,
      //   );
      // }
       else if (type == 2) {
        return Image.file(
          file!,
          height: height,
          width: width,
          fit: BoxFit.cover,
          color: color,
        );
      } else if (type == 3) {
        return CachedNetworkImage(
          imageUrl: url!,
          height: height,
          width: width,
          fit: fit,
          color: color,
          placeholder: (context, url) {
            return Center(child: CircularProgressIndicator());
          },
          errorWidget: (context, url, error) {
            return Image.asset(
              AssetConstants.back_button_icon,
              height: height,
              width: width,
              fit: BoxFit.cover,
            );
          },
        );
      } else {
        return Image.asset(
          path,
          height: height,
          width: width,
          fit: fit,
          color: color,
          colorBlendMode: BlendMode.srcATop,
        );
      }
    } catch (e) {
      return Container();
    }
  }
}
