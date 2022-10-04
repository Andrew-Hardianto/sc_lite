import 'package:flutter/material.dart';
import 'package:sc_lite/utils/extension.dart';

class PinScreen extends StatefulWidget {
  final String action;
  const PinScreen({super.key, required this.action});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
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
    print(currPin);
    if (currPin > 0) {
      currPin--;
      valuePin = valuePin.substring(0, -1);
    }
  }

  handlePin(num number) {
    currPin++;
    valuePin += number.toString();
    print(valuePin);
    if (currPin == maxPin) {
      checkPin();
    }
  }

  checkPin() {}

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
                const Text(
                  'Enter your PIN to Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.radio_button_on,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      Icons.radio_button_off,
                      color: '#3DC0F0'.toColor(),
                    ),
                    Icon(
                      Icons.radio_button_off,
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
