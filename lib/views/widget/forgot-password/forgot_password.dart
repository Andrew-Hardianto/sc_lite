import 'package:flutter/material.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:sc_lite/views/widget/error-modal/error_modal.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _employeeNoCtrl = TextEditingController();

  submit() {
    if (_emailCtrl.text.trim() == "") {
      Navigator.of(context).pop();
      showModalError('You need to fill Email!');
    } else if (_employeeNoCtrl.text.trim() == "") {
      Navigator.of(context).pop();
      showModalError('You need to fill Employee No!');
    } else {
      Map<String, String> dataPost = {
        'email': _emailCtrl.text,
        'employeeNo': _employeeNoCtrl.text
      };
      Navigator.of(context).pop(dataPost);
    }
  }

  showModalError(message) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: ErrorModal(
            message: message,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 270,
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 20,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Forgot Your Password?',
              style: TextStyle(
                color: '#595959'.toColor(),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              'Please enter your email\nand employee number to continue',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: '#767676'.toColor(),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              margin: const EdgeInsets.only(top: 10),
              height: 45,
              child: TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  hintText: 'Enter your Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(199, 199, 199, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(199, 199, 199, 1),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              margin: const EdgeInsets.only(top: 10),
              height: 45,
              child: TextField(
                controller: _employeeNoCtrl,
                decoration: const InputDecoration(
                  hintText: 'Enter your Employee No',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(199, 199, 199, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(199, 199, 199, 1),
                    ),
                  ),
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                margin: const EdgeInsets.only(top: 10),
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: '#e63232'.toColor(),
                          shadowColor: '#e63232'.toColor(),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 90,
                      child: ElevatedButton(
                        onPressed: submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: '#3dc0f0'.toColor(),
                          shadowColor: '#3dc0f0'.toColor(),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
