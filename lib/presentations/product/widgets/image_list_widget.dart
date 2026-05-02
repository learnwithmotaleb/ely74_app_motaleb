import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/api-client/api_service.dart';
import 'package:market_place/core/components/custom_network_image.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/helper/helper_function.dart';
import 'package:market_place/core/utils/variable.dart';
import 'package:market_place/presentations/sell-now/controller/sell_controller.dart';

class ListOfImages extends StatelessWidget {
  final RxList<String> images;
  final bool isNetworkImage ;
  final double? size;
  final bool? isShowCross;

  const ListOfImages({super.key, required this.images,  this.isNetworkImage =true, this.size, this.isShowCross =true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: Obx(() {
        return images.isEmpty
            ? SizedBox.shrink()
            : Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: List.generate(images.length, (index) {
                final img = images[index];
                return Stack(
                  children: [
                   isNetworkImage
                        ? CustomNetworkImage(
                          imageUrl: "${ApiService().baseUrl}/$img",
                          height:size?? 110.w,
                          width:size?? 110.w,
                        )
                        : Image.file(
                          File(img),
                          height:size?? 110.w,
                          width:size?? 110.w,
                          fit: BoxFit.cover,
                        ),
               isShowCross==true?     Positioned(
                      top: -10,
                      right: -10,

                      child: IconButton(
                        onPressed: () {
                          removeImage(uploadImages: images, imagePath: img);
                          if (isNetworkImage) {
                            SellController.to.removeImgList.add(img);
                            logger.d( SellController.to.removeImgList.length);
                          }
                        },
                        icon: Icon(
                          CupertinoIcons.multiply_circle_fill,
                          size: 20,
                          color: AppColors.kPrimaryColor,
                        ),
                      ),
                    ):SizedBox.shrink(),
                  ],
                );
              }),
            );
      }),
    );
  }
}
