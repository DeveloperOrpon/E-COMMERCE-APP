import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:green_mart/constant/app_color.dart';
import 'package:green_mart/core/model/Review.dart';
import 'package:green_mart/views/widgets/custom_app_bar.dart';
import 'package:green_mart/views/widgets/review_tile.dart';

class ReviewsPage extends StatefulWidget {
  final List<RatingModel> reviews;
  const ReviewsPage({super.key, required this.reviews});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  getAverageRating() {
    double average = 0.0;
    for (RatingModel ratingModel in widget.reviews) {
      average += num.parse(ratingModel.rating);
    }
    return num.parse((average / widget.reviews.length).toStringAsFixed(2))
        .toDouble();
  }

  countStarBasedReview(double value) {
    int count = 0;
    for (RatingModel ratingModel in widget.reviews) {
      if (num.parse(ratingModel.rating).toDouble() == value ||
          num.parse(ratingModel.rating).toDouble() == value + .5) {
        count++;
      }
    }
    return count;
  }

  List<RatingModel> filterRating = [];
  ratingList(double value) {
    filterRating = [];
    for (RatingModel ratingModel in widget.reviews) {
      if (num.parse(ratingModel.rating).toDouble() == value ||
          num.parse(ratingModel.rating).toDouble() == value + .5) {
        filterRating.add(ratingModel);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppBar(
            title: 'Reviews',
            leftIcon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
            rightIcon: SvgPicture.asset(
              'assets/icons/Bookmark.svg',
              color: Colors.black.withOpacity(0.5),
            ),
            leftOnTap: () {
              Navigator.of(context).pop();
            },
            rightOnTap: () {},
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            // Section 1 - Header
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      getAverageRating().toString(),
                      style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'poppins'),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBarIndicator(
                        rating: getAverageRating(),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 18.0,
                        direction: Axis.horizontal,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          'Based on ${widget.reviews.length} Reviews',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Section 2 - Tab
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 16, bottom: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor:
                          (_selectedTab == 0) ? AppColor.primary : Colors.white,
                    ),
                    child: Text(
                      'all reviews',
                      style: TextStyle(
                          color:
                              (_selectedTab == 0) ? Colors.white : Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 1;
                        ratingList(1);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.border,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      backgroundColor:
                          (_selectedTab == 1) ? AppColor.primary : Colors.white,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg',
                            width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '1(${countStarBasedReview(1)})',
                            style: TextStyle(
                                color: (_selectedTab == 1)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 2;
                        ratingList(2);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.border,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      backgroundColor:
                          (_selectedTab == 2) ? AppColor.primary : Colors.white,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg',
                            width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '2(${countStarBasedReview(2)})',
                            style: TextStyle(
                                color: (_selectedTab == 2)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 3;
                        ratingList(3);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.border,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      backgroundColor:
                          (_selectedTab == 3) ? AppColor.primary : Colors.white,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg',
                            width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '3(${countStarBasedReview(3)})',
                            style: TextStyle(
                                color: (_selectedTab == 3)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 4;
                        ratingList(4);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.border,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      backgroundColor:
                          (_selectedTab == 4) ? AppColor.primary : Colors.white,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg',
                            width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '4(${countStarBasedReview(4)})',
                            style: TextStyle(
                                color: (_selectedTab == 4)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = 5;
                        ratingList(5);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.border,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.border, width: 1),
                      ),
                      backgroundColor:
                          (_selectedTab == 5) ? AppColor.primary : Colors.white,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg',
                            width: 14, height: 14),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            '5(${countStarBasedReview(5)})',
                            style: TextStyle(
                                color: (_selectedTab == 5)
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Section 3 - List Review
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ReviewTile(
                  review: _selectedTab == 0
                      ? widget.reviews[index]
                      : filterRating[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: _selectedTab == 0
                  ? widget.reviews.length
                  : filterRating.length,
            )
          ],
        ),
      ),
    );
  }
}
