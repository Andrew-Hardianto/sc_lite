import 'package:flutter/material.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:sc_lite/utils/extension.dart';

class CheckinoutListScreen extends StatefulWidget {
  static const String routeName = '/transaction/checkinout';
  const CheckinoutListScreen({super.key});

  @override
  State<CheckinoutListScreen> createState() => _CheckinoutListScreenState();
}

class _CheckinoutListScreenState extends State<CheckinoutListScreen> {
  final mainService = MainService();
  final TextEditingController filter = new TextEditingController();

  dynamic type;
  String activeDataStatus = 'In Progress';

  List status = [
    {'name': 'Waiting', 'value': 'In Progress'},
    {'name': 'Approved', 'value': 'Approved'},
    {'name': 'Rejected', 'value': 'Rejected'},
    {'name': 'Canceled', 'value': 'Canceled'},
  ];

  @override
  Widget build(BuildContext context) {
    Map params = ModalRoute.of(context)!.settings.arguments as Map;
    type = params['type'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const TextAppbar(text: 'Check In / Out Status'),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    width: (MediaQuery.of(context).size.width / 100) * 65,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: '#F5F5F5'.toColor(),
                      border: Border.all(
                        color: const Color.fromRGBO(199, 199, 199, 1),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: filter,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person_outline),
                        iconColor: Colors.grey,
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 55,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: '#F5F5F5'.toColor(),
                        side: BorderSide(
                          color: '#c0c0c0'.toColor(),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Icon(
                        Icons.search,
                        color: '#3DC0F0'.toColor(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 55,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: '#F5F5F5'.toColor(),
                        side: BorderSide(
                          color: '#c0c0c0'.toColor(),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Icon(
                        Icons.filter_list,
                        color: '#3DC0F0'.toColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                // height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: '#3DC0F0'.toColor(),
                          ),
                        ),
                      ),
                      child: Text(
                        'WAITING(0)',
                        style: TextStyle(
                          color: '#3DC0F0'.toColor(),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: '#3DC0F0'.toColor(),
                          ),
                        ),
                      ),
                      child: Text(
                        'APPROVED',
                        style: TextStyle(
                          color: '#3DC0F0'.toColor(),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: '#3DC0F0'.toColor(),
                          ),
                        ),
                      ),
                      child: Text(
                        'REJECTED',
                        style: TextStyle(
                          color: '#3DC0F0'.toColor(),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: '#3DC0F0'.toColor(),
                          ),
                        ),
                      ),
                      child: Text(
                        'CANCELED',
                        style: TextStyle(
                          color: '#3DC0F0'.toColor(),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
