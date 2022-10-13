import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/screen/transaction/transaction-detail/checkinout-detail/checkinout_detail.dart';
import 'package:sc_lite/views/widget/approval-map/approval_map.dart';
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
  final ScrollController scrollController = ScrollController();

  dynamic type;
  String activeDataStatus = 'In Progress';
  List listData = [];

  double latitude = -7.05770065;
  double longitude = 110.41586081;

  num indexPaging = 0;
  num sizeData = 100;

  DateTime? startDate;
  DateTime? endDate;
  List arrayDataApprovalId = [];
  List dataSelectCheck = [];
  List arrMarker = [];

  num dataCount = 0;

  String? randomColor;

  bool selectAll = false;

  bool searchActive = false;
  // bool skeletonMap = true;

  List status = [
    {
      'name': 'Waiting',
      'value': 'In Progress',
      'active': true,
    },
    {
      'name': 'Approved',
      'value': 'Approved',
      'active': false,
    },
    {
      'name': 'Rejected',
      'value': 'Rejected',
      'active': false,
    },
    {
      'name': 'Canceled',
      'value': 'Canceled',
      'active': false,
    },
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getListData(activeDataStatus);
    filter.addListener(isFilterEmpty);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  isFilterEmpty() {
    if (filter.text.length > 2) {
      setState(() {
        searchActive = true;
      });
    } else if (filter.text.length < 3) {
      setState(() {
        searchActive = false;
      });
    }
  }

  selectSegment(String type) {
    listData.clear();
    getListData(type);
    if (type == 'Approved') {
      for (var element in status) {
        setState(() {
          activeDataStatus = type;
          element['active'] = false;
          status[1]['active'] = true;
          scrollController.animateTo(
            scrollController.position.maxScrollExtent / 2,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        });
      }
    } else if (type == 'Rejected') {
      for (var element in status) {
        setState(() {
          activeDataStatus = type;
          element['active'] = false;
          status[2]['active'] = true;
          scrollController.animateTo(
            scrollController.position.maxScrollExtent / 3,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        });
      }
    } else if (type == 'Canceled') {
      for (var element in status) {
        setState(() {
          activeDataStatus = type;
          element['active'] = false;
          status[3]['active'] = true;
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        });
      }
    } else {
      for (var element in status) {
        setState(() {
          activeDataStatus = type;
          element['active'] = false;
          status[0]['active'] = true;
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        });
      }
    }
  }

  searchData() {}

  getListData(String dataStatus) async {
    String urlApi = await mainService.urlApi();

    randomColor = await mainService.getRandomColor();

    if (dataStatus == 'In Progress' && type == 'Approval') {
      urlApi +=
          "/api/user/self-service/check-in-out/request/approval/need-approval?status=$dataStatus";
    } else if (dataStatus == 'In Progress' || type == 'Status') {
      urlApi +=
          "/api/user/self-service/check-in-out/status/my-request?status=$dataStatus";
    } else {
      urlApi +=
          "/api/user/self-service/check-in-out/request/approval/approval-history?status=$dataStatus";
    }

    if (endDate != null) {
      urlApi =
          '$urlApi&requestDateEnd=${DateFormat('yyyy-MM-dd').format(endDate!)}';
    }

    if (type == 'Status') {
      // urlApi = "$urlApi&sortDirection=DESC&sortBy=actualTime";
      urlApi = "$urlApi&orderBy=DESC";
    } else {
      dataStatus == 'In Progress'
          // ? urlApi = "$urlApi&sortDirection=ASC&sortBy=actualTime"
          // : urlApi = "$urlApi&sortDirection=DESC&sortBy=ar.actualTime";
          ? urlApi = "$urlApi&orderBy=ASC"
          : urlApi = "$urlApi&orderBy=DESC";
    }

    mainService.getUrlHttp(urlApi, true, (res) {
      if (res.statusCode == 200) {
        mainService.hideLoading();
        var data = jsonDecode(res.body);

        setState(() {
          listData = data;
          if (dataStatus == 'In Progress') {
            dataCount = listData.length;
          }
          if (activeDataStatus == 'In Progress' && type == "Approval") {
            for (var element in listData) {
              element['check'] = false;
            }
          }
        });
      } else {
        mainService.hideLoading();
        if (mounted) {
          mainService.errorHandlingHttp(res, context);
        }
      }
    });
  }

  goToDetail(data) {
    Map params = {
      'transactionName': 'CheckInOut',
      'transactionType': type,
      'dataStatus': activeDataStatus,
      'data': data
    };
    Navigator.of(context).pushNamed(
      CheckinoutDetail.routeName,
      arguments: params,
    );
  }

  checkEvent(val, dynamic requestId) {
    var totalItems = listData.length;
    var idx = listData.indexWhere((res) => res['requestId'] == requestId);

    setState(() {
      listData[idx]['check'] = val;

      var checked = 0;
      listData.map((obj) {
        if (obj['check']) checked++;
      });

      if (checked < totalItems - 1) {
        selectAll = false;
      } else if (checked == totalItems) {
        selectAll = true;
      } else {
        selectAll = false;
      }
    });

    handleMarker(listData[idx]);
  }

  handleMarker(data) {
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    Map params = ModalRoute.of(context)!.settings.arguments as Map;
    type = params['type'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: TextAppbar(text: 'Check In / Out $type'),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    width: (MediaQuery.of(context).size.width / 100) * 60,
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
                      onPressed: !searchActive ? null : () {},
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
              controller: scrollController,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 40,
                child: Row(
                  children: status
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            selectSegment(e['value']);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: e["active"]
                                    ? BorderSide(
                                        color: '#3DC0F0'.toColor(),
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: Text(
                              '${e["name"].toUpperCase()}${e["name"] == "Waiting" ? "($dataCount)" : ""}',
                              style: TextStyle(
                                color: e["active"]
                                    ? '#3DC0F0'.toColor()
                                    : Colors.black45,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            if (listData.isEmpty)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/image/nodata.svg',
                        width: 160,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'No Submissions',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'You do not have any application',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      const Text(
                        'for Check In / Out',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            if (listData.isNotEmpty && type == "Status")
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: listData
                        .map(
                          (e) => Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            height: 150,
                            child: InkWell(
                              onTap: () {
                                goToDetail(e);
                              },
                              child: Card(
                                color: '#F3F3F3'.toColor(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e['requestNo'],
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                DateFormat('dd MMM yyyy')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            e['requestDateMilliSecond'])),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "Approval ${e['progressApproval']}",
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${e['type'] == 'Check In' ? 'Check In' : 'Check Out'} - ${e['outOffice'] ? 'Out of Office' : 'In Office'}",
                                        style: TextStyle(
                                          color: '#3DC0F0'.toColor(),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd MMM yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                e['actualTimeMilliSecond'])),
                                      ),
                                      Text(
                                        '${e["purposeValue"] ?? "-"}',
                                      ),
                                      Text(
                                        '${e["approverName"] ?? "-"} ',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            if (listData.isNotEmpty &&
                type == "Approval" &&
                activeDataStatus == "In Progress")
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: '#F3F3F3'.toColor(),
                      ),
                      child: ApprovalMap(
                        lat: latitude,
                        lng: longitude,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'REJECT',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 120,
                          // margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                '#29a7b8'.toColor(),
                                '#3df06f'.toColor(),
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: const [0.1, 0.9],
                              tileMode: TileMode.clamp,
                              transform: const GradientRotation(pi / 6),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.blue.shade200,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'APPROVE',
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Checkbox(
                          shape: const CircleBorder(),
                          value: selectAll,
                          onChanged: (value) {
                            setState(() {
                              selectAll = value!;
                            });
                          },
                        ),
                        const Text(
                          'Select All',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
            if (listData.isNotEmpty && type == "Approval")
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: listData
                        .map(
                          (e) => Row(
                            children: [
                              if (activeDataStatus == 'In Progress')
                                Checkbox(
                                  shape: const CircleBorder(),
                                  value: e['check'],
                                  onChanged: (value) {
                                    checkEvent(value, e['requestId']);
                                  },
                                ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                height: 150,
                                width: activeDataStatus == 'In Progress'
                                    ? MediaQuery.of(context).size.width / 1.3
                                    : MediaQuery.of(context).size.width - 50,
                                child: InkWell(
                                  onTap: () {
                                    if (activeDataStatus != "In Progress") {
                                      goToDetail(e);
                                    }
                                  },
                                  child: Card(
                                    color: '#F3F3F3'.toColor(),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          if (e['employeeProfile'] != null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                e['employeeProfile'],
                                                width: 60.0,
                                                height: 60.0,
                                              ),
                                            ),
                                          if (e['employeeProfile'] == null)
                                            Container(
                                              width: 60.0,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color: randomColor == null
                                                    ? '#121212'.toColor()
                                                    : '$randomColor'.toColor(),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  e['alias'] ?? '-',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: activeDataStatus ==
                                                    "In Progress"
                                                ? 170
                                                : 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e['employeeName'],
                                                  softWrap: true,
                                                  overflow: TextOverflow.clip,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  e['employeeNo'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  e['type'] == 'Check In'
                                                      ? 'Check In'
                                                      : 'Check Out',
                                                  style: TextStyle(
                                                    color: '#3DC0F0'.toColor(),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('dd MMM yyyy')
                                                      .format(DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              e['actualTimeMilliSecond'])),
                                                ),
                                                Text(
                                                  '${e["purposeValue"] ?? "-"}',
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
