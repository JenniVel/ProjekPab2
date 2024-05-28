import 'package:flutter/material.dart';
import 'package:projek/screens/home/details_page.dart';
import 'package:projek/models/people_also_like_model.dart';
import 'package:projek/screens/widgets/reuseable_text.dart';
import 'package:projek/models/wisata.dart';

class WisataWidget extends StatelessWidget {
  
  const WisataWidget({
    Key? key,
    required this.index,
    required this.combinedPeopleAlsoLikeModelList,
  }) : super(key: key);

  final int index;
  final List<PeopleAlsoLikeModel> combinedPeopleAlsoLikeModelList;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      // onTap: () => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DetailsPage(
      //       personData: combinedPeopleAlsoLikeModelList[index],
      //       isCameFromPersonSection: true,
      //       id: combinedPeopleAlsoLikeModelList[index].id,
      //     ),
      //   ),
      // ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: size.width,
        height: size.height * 0.15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: combinedPeopleAlsoLikeModelList[index].day,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                width: size.width * 0.28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(
                      combinedPeopleAlsoLikeModelList[index].image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.035,
                  ),
                  AppText(
                    text: combinedPeopleAlsoLikeModelList[index].title,
                    size: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  AppText(
                    text: combinedPeopleAlsoLikeModelList[index].location,
                    size: 14,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w300,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.015),
                    child: AppText(
                      text: "${combinedPeopleAlsoLikeModelList[index].day} Day",
                      size: 14,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
