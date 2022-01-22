library rupadana;

import 'package:flutter/material.dart' hide Step;
import 'package:rupadana/button_step.dart';
import 'package:rupadana/step.dart';

class Stepper extends StatefulWidget {
  final List<Step> steps;
  StepperConfig? config;
  Stepper({required this.steps, Key? key, this.config}) : super(key: key) {
    if(config == null) {
      config = StepperConfig();
    }
  }

  @override
  _StepperState createState() => _StepperState();
}

class StepperColors {
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color greyOverlay = Color(0xffC4C4C4);
  static const Color darkGrey = Color(0xff79747E);
  static const Color primary = Color(0xff0E4DA4);
  static const Color yellowSoft = Color(0xffFFF3CD);

}
class _StepperState extends State<Stepper> with SingleTickerProviderStateMixin {
  int currentPage = 0;
  int totalPage = 0;
  double totalWidth = 0;
  double widthIndicator = 0;
  double widthPerIndicator = 0;
  SnackbarFormError? mySnackbar;
  final PageController _pageController = PageController();

  


  @override
  void initState() {
    super.initState();
    totalPage = widget.steps.length;
  }

  Widget getPage() {
    return widget.steps[currentPage];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widthIndicator = MediaQuery.of(context).size.width / totalPage;
    widthPerIndicator = MediaQuery.of(context).size.width / totalPage;
  }

  void nextPage() {
    mySnackbar = SnackbarFormError(context: context);
    if (widget.steps[currentPage].validation!() != null) {
      StepperMessage? _stepperMessage = widget.steps[currentPage].validation!();
      mySnackbar!.showMySnackBar("${_stepperMessage!.title}",
          "${_stepperMessage.message}");
      return;
    }
    if (currentPage < totalPage) {
      setState(() {
        currentPage++;
        widthIndicator += widthPerIndicator;
        _pageController.animateToPage(currentPage, duration: const Duration(milliseconds: 500), curve:Curves.ease);
      });
    }
  }

  void prevPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        widthIndicator -= widthPerIndicator;
        _pageController.animateToPage(currentPage, duration: const Duration(milliseconds: 500), curve:Curves.ease);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    totalWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 11,
            color: StepperColors.white,
            child: Row(
              children: widget.steps.asMap().entries.map<Widget>((e) {
                int _index = e.key;
                Step _step = e.value;
                double _width = currentPage == _index
                    ? (totalWidth * totalPage) / (totalPage + (totalPage - 1))
                    : (totalWidth * 1) / (totalPage + (totalPage - 1));
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: _width,
                  child: BallsIndicators(
                    title: _step.title,
                    index: _index + 1,
                    isComplete: currentPage > _index,
                    isActive: currentPage == _index,
                  ),
                );
              }).toList(),
            ),
          ),
          // BallsIndicators(),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 3,
                decoration: const BoxDecoration(
                  color: StepperColors.greyOverlay,
                ),
              ),
              indicator(),
            ],
          ),
          // PageView(
          //   children: widget.steps,
          // ),
          // Expanded(flex: 1, child: getPage()),
          Expanded(
            flex: 1,
            child: PageView(
              pageSnapping: true,
              controller: _pageController,
              children: widget.steps,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: StepperColors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            height: MediaQuery.of(context).size.height / 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPage == 1
                    ? ButtonStep(
                        iconColors: StepperColors.darkGrey,
                        textColors: StepperColors.darkGrey,
                        colors: StepperColors.white,
                        text: "${widget.config!.buttonPrevPageText}",
                        onPressed: prevPage,
                      )
                    : const SizedBox.shrink(),
                currentPage == widget.steps.length - 1
                    ? ButtonStep(
                        isNext: true,
                        colors: StepperColors.primary,
                        text: "${widget.config!.buttonFinishText}",
                        onPressed: () {
                          setState(() {
                            currentPage = 0;
                            totalPage = widget.steps.length;
                            widthIndicator = MediaQuery.of(context).size.width / totalPage;
                            widthPerIndicator = MediaQuery.of(context).size.width / totalPage;
                          });
                        },
                      )
                    : ButtonStep(
                        isNext: true,
                        colors: StepperColors.primary,
                        text: "${widget.config!.buttonNextPageText}",
                        onPressed: nextPage,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget indicator() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 3,
            width: widthIndicator,
            color: StepperColors.primary,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}



class StepperConfig {
  String? buttonNextPageText = "Next";
  String? buttonPrevPageText = "Previous";
  String? buttonFinishText = "Submit";

  StepperConfig({this.buttonFinishText = "Submit",this.buttonPrevPageText = "Previous", this.buttonNextPageText = "Next"});
}

class SnackbarFormError {
  BuildContext context;
  String? title;
  String? subtitle;
  SnackbarFormError({required this.context});

  void showMySnackBar(String title, String subtitle) {
    final mySnackBar = SnackBar(
      dismissDirection: DismissDirection.down,
      duration: const Duration(seconds: 3),
      backgroundColor: StepperColors.yellowSoft,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: StepperColors.black, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            subtitle,
            style: const TextStyle(
                color: StepperColors.black, fontWeight: FontWeight.w400),
          )
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 11, left: 22, right: 22),
    );
    ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
  }
}


class BallsIndicators extends StatelessWidget {
  final int? index;
  final String? title;
  final bool? isActive;
  final bool? isComplete;

  const BallsIndicators(
      {this.index, this.title, this.isActive, this.isComplete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: isComplete!
                ? const Icon(
                    Icons.done,
                    color: StepperColors.white,
                    size: 10,
                  )
                : AnimatedContainer(
                    duration: const Duration(milliseconds: 3000),
                    curve: Curves.bounceIn,
                    child: Text(
                      index.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isActive!
                              ? StepperColors.white
                              : StepperColors.greyOverlay),
                    ),
                  ),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  )
                ],
                color: isComplete!
                    ? StepperColors.primary
                    : isActive!
                        ? StepperColors.primary
                        : StepperColors.white,
                shape: BoxShape.circle),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: AnimatedOpacity(
              opacity: isActive == true ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Text(
                // "",
                title!,
                style: const TextStyle(fontWeight: FontWeight.w100),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}


class StepperMessage {
  String? title;
  String? message;

  StepperMessage({
    this.title = "Something is missing in the form",
    this.message = "please check the form",
  });
}