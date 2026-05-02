import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market_place/core/components/custom_loading_widget.dart';
import 'package:market_place/core/utils/variable.dart';


import '../constants/image_constants.dart';

class CustomNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Border? border;
  final double? radius;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final String? imageErrorUrl;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.imageErrorUrl,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.radius,
    this.boxShape = BoxShape.rectangle,
    this.borderRadius, this.fit,
  });

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  @override
  Widget build(BuildContext context) {
    // final cleanedUrl = widget.imageUrl.replaceAll(RegExp(r'/+'), '/');

    bool isSvgUrl(String url) {
      final uri = Uri.tryParse(url);
      if (uri == null) return false;

      final path = uri.path.toLowerCase();
      return path.endsWith('.svg');
    }

    return isSvgUrl(widget.imageUrl)
        ? Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              border: widget.border,
              borderRadius: widget.boxShape == BoxShape.circle
                  ? null
                  : widget.borderRadius ??
                      BorderRadius.circular(widget.radius ?? 8.r),
              shape: widget.boxShape,
              color: widget.backgroundColor,
            ),
            child: SvgPicture.network(
              widget.imageUrl,
              fit:widget.fit?? BoxFit.cover,
              placeholderBuilder: (context) => CustomLoadingWidget(
                height: widget.height,
                size: 30.sp,
                width: widget.width,
              ),
              errorBuilder: (context, error, stackTrace){
                logger.e(error);
                return Container(
                  height: widget.height,
                  width: widget.width,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: widget.border,
                    borderRadius: widget.boxShape == BoxShape.circle
                        ? null
                        : BorderRadius.circular(widget.radius ?? 8.r),
                    shape: widget.boxShape,
                    color: Colors.grey.withValues(alpha:0.6),
                    // image: DecorationImage(
                    //   image: Svg(imageErrorUrl ?? ''),
                    //        fit:widget.fit?? BoxFit.cover,

                    // ),
                  ),
                  child: SvgPicture.asset(
                    widget.imageErrorUrl ?? placeholderImage,
                         fit:widget.fit?? BoxFit.cover,

                    height: widget.height,
                    width: widget.width,
                  ),
                );
              },
            ),
          )
        : CachedNetworkImage(
      fadeInDuration: Duration.zero, // <— disables transition animation
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      fit:widget.fit?? BoxFit.cover,
            imageUrl: widget.imageUrl,
            imageBuilder: (context, imageProvider) {
              return Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  border: widget.border,
                  borderRadius: widget.boxShape == BoxShape.circle
                      ? null
                      : widget.borderRadius ??
                          BorderRadius.circular(widget.radius ?? 8.r),
                  shape: widget.boxShape,
                  color: widget.backgroundColor,
                  image: DecorationImage(
                    image: imageProvider,
                         fit:widget.fit?? BoxFit.cover,

                    colorFilter: widget.colorFilter,
                  ),
                ),
                child: widget.child,
              );
            },
            placeholder: (context, url) {
              return CustomLoadingWidget(
                height: widget.height,
                size: 30.sp,
                width: widget.width,
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                height: widget.height,
                width: widget.width,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: widget.border,
                  borderRadius: widget.boxShape == BoxShape.circle
                      ? null
                      : BorderRadius.circular(widget.radius ?? 8.r),
                  shape: widget.boxShape,
                  color: Colors.grey.withValues(alpha: 0.6),
                  // image: DecorationImage(
                  //   image: Svg(imageErrorUrl ?? ''),
                  //        fit:widget.fit?? BoxFit.cover,

                  // ),
                ),
                child: SvgPicture.asset(
                  widget.imageErrorUrl ?? placeholderImage,
                       fit:widget.fit?? BoxFit.cover,

                  height: widget.height,
                  width: widget.width,
                ),
              );
            },
          );
  }
}
