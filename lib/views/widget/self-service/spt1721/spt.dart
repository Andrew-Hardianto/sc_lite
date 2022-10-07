import 'package:flutter/material.dart';
import 'package:sc_lite/utils/extension.dart';

class SptModal extends StatefulWidget {
  final dynamic optPeriod;
  const SptModal({super.key, required this.optPeriod});

  @override
  State<SptModal> createState() => _SptModalState();
}

class _SptModalState extends State<SptModal> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 0.6,
      child: Container(
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(color: '#F7F7F7'.toColor()),
              child: Text(
                '1721A1',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: '#5B5B5B'.toColor(),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Choose tax period',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: '#5B5B5B'.toColor(),
                    ),
                  ),
                  Text(
                    'You can choose more than 1 period',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: '#5B5B5B'.toColor(),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: '#C0C0C0'.toColor(),
                      ),
                    ),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            shape: const CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                check = value!;
                              });
                            },
                            value: check,
                          ),
                        ),
                        Text(
                          '2022',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 120,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 130,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: '#D0D0D0'.toColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 130,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: ['#3DC0F0'.toColor(), '#3D8FF0'.toColor()],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.5, 0.8]),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.blue.shade200,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Download',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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
