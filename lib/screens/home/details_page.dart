import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../models/people_also_like_mode.dart';
import '../widgets/reuseable_text.dart';
import '../models/tempat_wisata.dart';
import 'package:quickalert/quickalert.dart';

class DetailsPage extends StatefulWidget {
  final int id;
  const DetailsPage({
    super.key,
    required this.personData,
    required this.isCameFromPersonSection,
    required this.id,
  });

  final PeopleAlsoLikeModel? personData;
  final bool isCameFromPersonSection;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController datetimeinput = TextEditingController();
  int selected = 0;
  final EdgeInsetsGeometry padding =
      const EdgeInsets.symmetric(horizontal: 20.0);
  dynamic current;

  onFirstLoaded() {
    if (widget.personData != null) {
      return current = widget.personData;
    }
  }

  Future<void> _selectDate() async {
    DateTimeRange? _picked = await showDateRangePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        datetimeinput.text = _picked.toString().split(" ")[0] +
            "   " +
            _picked.toString().split(" ")[2] +
            "   " +
            _picked.toString().split(" ")[3];
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    Size size = MediaQuery.of(context).size;

    final List<PeopleAlsoLikeModel> _peopleAlsoLikeModelList =
        PeopleAlsoLikeModel.peopleAlsoLikeModeList+
        PeopleAlsoLikeModel.peopleAlsoLikeModeList1+
        PeopleAlsoLikeModel.inspiration+
        PeopleAlsoLikeModel.perkotaan+
        PeopleAlsoLikeModel.places+
        PeopleAlsoLikeModel.popular;

    onFirstLoaded();

    bool toggleIsFavorite(bool isFavorite) {
      return !isFavorite;
    }

    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Transaction Completed Successfully!',
      );
    }

    return Scaffold(
        backgroundColor: Colors.blue.shade50,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Hero(
                  tag: widget.isCameFromPersonSection
                      ? widget.personData?.day.toString() ?? ''
                      : widget.personData?.image ?? '',
                  child: Container(
                    width: size.width,
                    height: size.height * 0.45,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                        widget.isCameFromPersonSection
                            ? widget.personData?.image ?? ''
                            : widget.personData?.image ?? '',
                      ),
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  padding: padding,
                  width: size.width,
                  height: size.height * 0.65,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: EdgeInsets.only(top: size.height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: current.title,
                                      size: 28,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.black54,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.01,
                                        ),
                                        AppText(
                                          text: current.location,
                                          size: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                AppText(
                                  text: "\Rp. ${current.price}",
                                  size: 25,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: Row(
                            children: [
                              Wrap(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < 4 ? Icons.star : Icons.star_border,
                                    color:
                                        index < 4 ? Colors.amber : Colors.grey,
                                  );
                                }),
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              const AppText(
                                text: "(4.0)",
                                size: 15,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: const AppText(
                            text: "Orang",
                            size: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.002),
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: const AppText(
                            text: "Berapa jumlah orang didalam grupmu",
                            size: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 600),
                          child: Container(
                            margin: EdgeInsets.only(top: size.height * 0.01),
                            width: size.width * 0.9,
                            height: size.height * 0.08,
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: 7,
                                itemBuilder: (ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: AnimatedContainer(
                                        width: size.width * 0.12,
                                        decoration: BoxDecoration(
                                          color: selected == index
                                              ? Colors.black
                                              : const Color.fromARGB(
                                                  255, 245, 245, 245),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: Center(
                                          child: Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: selected == index
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        FadeInUp(
                          delay: const Duration(milliseconds: 800),
                          child: const AppText(
                            text: "Pilih Tanggal",
                            size: 21,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        FadeInUp(
                          delay: const Duration(milliseconds: 900),
                          child: Container(
                            child: TextFormField(
                              controller: datetimeinput,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.black,
                                ),
                                labelText: "Masukkan Tanggal",
                                labelStyle: TextStyle(color: Colors.black),
                                filled: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              readOnly: true,
                              onTap: () {
                                _selectDate();
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        FadeInUp(
                          delay: const Duration(milliseconds: 1000),
                          child: const AppText(
                            text: "Deskripsi",
                            size: 21,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        FadeInUp(
                          delay: const Duration(milliseconds: 1100),
                          child: AppText(
                            text: current.description,
                            size: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: size.height * 0.08),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: Padding(
                  padding: EdgeInsets.all(size.height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          debugPrint('favorite');
                        },
                        child: Container(
                          width: size.width * 0.14,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 26, 123, 214),
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                bool isFavorite = toggleIsFavorite(
                                    _peopleAlsoLikeModelList[widget.id]
                                        .isFavorite);
                                _peopleAlsoLikeModelList[widget.id].isFavorite =
                                    isFavorite;
                              });
                            },
                            icon: Icon(
                              _peopleAlsoLikeModelList[widget.id].isFavorite ==
                                      true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Color.fromARGB(255, 26, 123, 214),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minWidth: size.width * 0.6,
                        height: size.height * 0.06,
                        color: Color.fromARGB(255, 26, 123, 214),
                        onPressed: () {
                          showAlert();
                        },
                        child: const AppText(
                          text: "Pesan Sekarang",
                          size: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return const ReviewScreen();
            // }));
          },
          icon: const Icon(Icons.reviews),
        ),
      ],
    );
  }
}
