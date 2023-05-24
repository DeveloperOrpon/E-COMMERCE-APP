import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/core/model/Review.dart';

class ReviewTile extends StatelessWidget {
  final RatingModel review;

  ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Photo
          Container(
              width: 36,
              height: 36,
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: review.userModel.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: review.userModel.imageUrl!,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const SpinKitPianoWave(
                        color: AppColor.primary,
                        size: 20.0,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : TextAvatar(
                      text: review.userModel.displayName,
                      size: 30,
                    )),
          // Username - Rating - Comments
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username - Rating
                Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 8,
                            child: Text(
                              '${review.userModel.displayName}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primary,
                                  fontFamily: 'poppins'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${review.review}',
                            style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.7),
                                height: 150 / 100),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 4,
                            child: RatingBar.builder(
                                allowHalfRating: false,
                                itemSize: 16,
                                glowColor: Colors.orange[400],
                                initialRating:
                                    num.parse(review.rating).toDouble(),
                                unratedColor: AppColor.primarySoft,
                                onRatingUpdate: (double value) {},
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Comments
              ],
            ),
          ),
        ],
      ),
    );
  }
}
