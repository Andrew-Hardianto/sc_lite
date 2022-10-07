import 'package:flutter/material.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:sc_lite/views/widget/snackbar/snackbar_message.dart';

class PinScreen extends StatefulWidget {
  final String type;
  const PinScreen({super.key, required this.type});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final mainService = MainService();
  String? otp;
  num page = 1;

  String myPin = "123456";
  String? tempPin;
  String? tempPin2;

  num maxPin = 6;
  num currPin = 0;
  String valuePin = "";
  dynamic pinStatus;

  deletePin() {
    setState(() {
      if (currPin > 0) {
        currPin--;
        valuePin = valuePin.substring(0, valuePin.length - 1);
      }
    });
  }

  handlePin(num number) {
    setState(() {
      currPin++;
      valuePin += number.toString();
      if (currPin == maxPin) {
        checkPin();
      }
    });
  }

  forgotPin() async {
    String urlApi = '${await mainService.urlApi()}/api/v1/user/pin/requestotp';

    mainService.getUrlHttp(urlApi, true, (dynamic res) {
      mainService.hideLoading();
      Navigator.of(context).pop({'type': 'forgot', 'response': res});
    });
  }

  checkPin() {
    if (widget.type == 'change') {
      if (page == 1) {
        tempPin = valuePin;

        Map data = {'pin': valuePin};

        valuePin = '';
        currPin = 0;

        handleValidation('validation', data, (dynamic res) {
          if (res.statusCode) {
            setState(() {
              page = 2;
            });
          } else {
            mainService.errorHandlingHttp(res, context);
          }
        });
      } else if (page == 2) {
        tempPin2 = valuePin;
        valuePin = '';
        currPin = 0;
        page = 3;
      } else if (page == 3) {
        Map data = {
          'oldPin': tempPin,
          'newPin': tempPin2,
          'confirmationPin': valuePin
        };

        tempPin2 = '';
        valuePin = '';
        currPin = 0;

        handleValidation('change', data, (dynamic res) {
          if (res.statusCode == 200) {
            Navigator.of(context)
                .pop({'type': 'change', 'message': res.message});
          } else {
            setState(() {
              page = 2;
            });
            mainService.errorHandlingHttp(res, context);
          }
        });
      }
    } else if (widget.type == 'setup') {
      if (page == 1) {
        tempPin = valuePin;
        valuePin = '';
        currPin = 0;
        page = 2;
      } else if (page == 2) {
        Map data = {'newPin': tempPin, 'confirmationPin': valuePin};

        valuePin = '';
        currPin = 0;

        handleValidation('setup', data, (dynamic res) {
          if (res.statuscode == 200) {
            Navigator.of(context)
                .pop({'type': 'setup', 'message': res.message});
          } else {
            mainService.errorHandlingHttp(res, context);
          }
        });
      }
    } else if (widget.type == 'payslip' || widget.type == 'spt') {
      Map data = {'pin': valuePin};

      valuePin = '';
      currPin = 0;

      handleValidation('validation', data, (dynamic res) {
        if (res.statusCode == 200) {
          Navigator.of(context).pop({'type': widget.type});
        } else {
          // mainService.errorHandlingHttp(res, context);
          showSnackbarError(context, 'Invalid PIN!');
        }
      });
    } else if (widget.type == 'reset') {
      if (page == 1) {
        tempPin = valuePin;
        valuePin = '';
        currPin = 0;
        page = 2;
      } else if (page == 2) {
        Map data = {'newPin': tempPin, 'confirmationPin': valuePin};

        valuePin = '';
        currPin = 0;

        handleValidation('reset', data, (dynamic res) {
          if (res.stausCode == 200) {
            Navigator.of(context)
                .pop({'type': 'reset', 'message': res.message});
          } else {
            setState(() {
              page = 1;
            });
            mainService.errorHandlingHttp(res, context);
          }
        });
      }
    }
  }

  Future handleValidation(String type, dynamic data, Function callback) async {
    String url = await mainService.urlApi();

    var urlApi;
    dynamic dataPost;

    if (type == 'setup') {
      urlApi = '$url/api/user/my-profile/pin/setup';
      dataPost = {
        'newPin': data['newPin'],
        'confirmationPin': data['confirmationPin']
      };
    } else if (type == 'change') {
      urlApi = '$url/api/user/my-profile/pin/change';
      dataPost = {
        'oldPin': data['oldPin'],
        'newPin': data['newPin'],
        'confirmationPin': data['confirmationPin']
      };
    } else if (type == 'validation') {
      urlApi = '$url/api/user/my-profile/pin/validation';
      dataPost = {'pin': data['pin']};
    } else if (type == 'reset') {
      urlApi = '$url/api/user/my-profile/pin/reset';
      dataPost = {
        'newPin': data['newPin'],
        'confirmationPin': data['confirmationPin'],
        'otp': otp
      };
    }

    return await mainService.postUrlApi(urlApi, true, dataPost, (res) {
      mainService.hideLoading();
      return callback(res);
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
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: '#3DC0F0'.toColor(),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                if ((widget.type == 'payslip' || widget.type == 'spt') &&
                    page == 1)
                  const Text(
                    'Enter your PIN to Continue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                if (widget.type == 'setup' && page == 1)
                  const Text(
                    'Setup Your New PIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                if (widget.type == 'setup' && page == 2)
                  const Text(
                    'Confirm Your New PIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                if (widget.type == 'change' && page == 1)
                  const Text(
                    'Enter Your Old PIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                if (widget.type == 'change' && page == 2)
                  const Text(
                    'Enter Your New PIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                if (widget.type == 'change' && page == 3)
                  const Text(
                    'Confirm Your Old PIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                if (widget.type == 'reset' && page == 1)
                  const Text(
                    'Enter Your New PIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                if (widget.type == 'reset' && page == 2)
                  const Text(
                    'Confirm Your New PIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      currPin > 0
                          ? Icons.radio_button_on
                          : Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      currPin > 1
                          ? Icons.radio_button_on
                          : Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      currPin > 2
                          ? Icons.radio_button_on
                          : Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      currPin > 3
                          ? Icons.radio_button_on
                          : Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      currPin > 4
                          ? Icons.radio_button_on
                          : Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      currPin > 5
                          ? Icons.radio_button_on
                          : Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 50,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((widget.type == 'payslip' || widget.type == 'spt') &&
                      page == 1)
                    Center(
                      child: InkWell(
                        child: Text(
                          'Forgot PIN',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => handlePin(1),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => handlePin(2),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => handlePin(3),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '3',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => handlePin(4),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '4',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => handlePin(5),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '5',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => handlePin(6),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '6',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => handlePin(7),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '7',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => handlePin(8),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '8',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => handlePin(9),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '9',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 75,
                        width: 75,
                      ),
                      ElevatedButton(
                        onPressed: () => handlePin(0),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color: '#3DC0F0'.toColor(), width: 2.5)),
                        child: Text(
                          '0',
                          style: TextStyle(
                            color: '#3DC0F0'.toColor(),
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 75,
                        height: 75,
                        child: IconButton(
                          onPressed: () => deletePin(),
                          icon: Icon(
                            Icons.backspace_outlined,
                            color: '#3DC0F0'.toColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
