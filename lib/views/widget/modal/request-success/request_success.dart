import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:sc_lite/utils/extension.dart';

class RequestSuccess extends StatefulWidget {
  final String title;
  final String statusType;
  final dynamic requestId;
  final dynamic params;
  const RequestSuccess({
    super.key,
    required this.title,
    required this.statusType,
    required this.requestId,
    required this.params,
  });

  @override
  State<RequestSuccess> createState() => _RequestSuccessState();
}

class _RequestSuccessState extends State<RequestSuccess> {
  String? header;
  String? info;
  String? quote;
  String? image;
  String confirmText = 'Okay, thank you';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getStart();
  }

  getStart() {
    switch (widget.title) {
      case "CheckInOut":
        header = "See You Tomorrow!";
        info = "";
        image =
            "assets/image/self-service/checkinout/checkout-illustration.png";
        quote = "Thank you for your hard work today, have a good rest!";
        confirmText = "Thank You !";
        break;
      case "Overtime":
        header = "Thank You!";
        info = "Your overtime request is being processed";
        image = "assets/image/self-service/overtime/overtime-illustration.png";
        quote = "Please wait for our next confirmation";
        break;
      case "Permission":
        if (widget.statusType != "") {
          switch (widget.statusType) {
            case "Marriage":
              header = "Wow Congrats!";
              info = "We're glad to know the happy news!";
              image =
                  "assets/image/self-service/permission/wedding-permission-illustration.png";
              quote =
                  "Our best wishes for your wedding! \n Please wait for our next confirmation";
              break;
            case "Permission":
              header = "Successfully Added!";
              info = "Your permission has been submitted!";
              image = "assets/image/self-service/general-illustration.png";
              quote =
                  "Take your seat, your permission is in process! \n Please wait for our next confirmation";
              break;
            case "Condolences":
              header = "Our Deep Condolences";
              info = "We are sorry for your loss";
              image =
                  "assets/image/self-service/permission/condolences-permission-illustration.png";
              quote =
                  "We hope your family will be given patience and fortitude \n Please wait for our next confirmation";
              break;
            default:
              break;
          }
        }
        break;
      case "Sick":
        if (widget.statusType != "") {
          switch (widget.statusType) {
            case "Sick":
              header = "Get well soon!";
              info = "Your sick application will be processed";
              image = "assets/image/self-service/sick/sick-illustration.png";
              quote = "Please wait for our next confirmation";
              break;
            default:
              break;
          }
        }
        break;
      case "Leave":
        if (widget.statusType != "") {
          switch (widget.statusType) {
            case "Leave":
              header = "Have a Nice Day!";
              info = "We hope your leave is fun!";
              image = "assets/image/self-service/leave/leave-illustration.png";
              quote = "Please wait for our next confirmation";
              break;
            case "Maternity":
              header = "Wow Congrats!";
              info = "We're glad to know the happy news!";
              image =
                  "assets/image/self-service/permission/children-permission-illustration.png";
              quote =
                  "Our best wishes for your family! \n Please wait for our next confirmation";
              break;
            default:
              break;
          }
        }
        break;
      case "Shift Change":
        header = "Thank You!";
        info = "";
        image =
            "assets/image/self-service/shift-change/success-submit-form-shift-change.svg";
        quote =
            "Your  request will be processed immediately, Please wait for our next confirmation";
        break;
      case "Time Off":
        header = "Thank You!";
        info = "";
        image =
            "assets/image/self-service/time-off/success-submit-form-time-off.svg";
        quote =
            "Your  request will be processed immediately, Please wait for our next confirmation";
    }
  }

  copyText() {
    final data = ClipboardData(text: widget.requestId);
    Clipboard.setData(data);
    // pasteText();
  }

  pasteText() async {
    Clipboard.getData(Clipboard.kTextPlain).then((value) {
      print(value!.text); //value is clipbarod data
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      '$header',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  widget.title == 'Shift Change' || widget.title == "Time Off"
                      ? SvgPicture.asset(image!)
                      : Image.asset(image!),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: const Text(
                      'Here is your request number',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.8,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: '#A1E6FF'.toColor(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.requestId}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            copyText();
                          },
                          icon: const Icon(
                            Icons.copy_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 20),
                    width: 150,
                    child: Text(
                      '$quote',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
