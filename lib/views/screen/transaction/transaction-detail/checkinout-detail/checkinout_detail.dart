import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sc_lite/service/main_service.dart';
import 'package:sc_lite/views/widget/text-appbar/text_appbar.dart';
import 'package:sc_lite/utils/extension.dart';
import 'package:shimmer/shimmer.dart';

class CheckinoutDetail extends StatefulWidget {
  static const String routeName = '/transaction/checkinout/checkinout-detail';
  const CheckinoutDetail({super.key});

  @override
  State<CheckinoutDetail> createState() => _CheckinoutDetailState();
}

class _CheckinoutDetailState extends State<CheckinoutDetail> {
  final mainService = MainService();
  final ScrollController scrollController = ScrollController();

  String segmentValue = 'Details';

  bool isSkeletonLoading = true;
  bool isActioned = true;
  bool isNoData = true;

  Map dataParams = {};
  dynamic type;

  String profilePict = 'assets/image/default_profile.png';
  String? randomColor;

  String? dataApprovalId;
  String? requestId;
  String? requestDate;
  String? checkInOutType;
  List dataApprovalAttachments = [];

  Map dataDetail = {};
  List historyApproval = [];
  String? dataStatus;
  bool segmentDetailActive = true;
  bool segmentApprovalActive = false;
  bool isApproved = false;
  Map dataType = {'Status': 'my-request', 'Approval': 'need-approval'};

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getDetail();
  }

  selectSegment(String status) {
    if (status == 'Details') {
      setState(() {
        segmentValue = status;
        segmentDetailActive = true;
        segmentApprovalActive = false;
        isSkeletonLoading = true;
      });
      getDetail();
    } else if (status == 'Approval') {
      getDataHistoryApproval();
      setState(() {
        segmentValue = status;
        segmentDetailActive = false;
        segmentApprovalActive = true;
      });
    }
  }

  getDetail() async {
    String urlApi = await mainService.urlApi();

    if (type == "Approval") {
      urlApi +=
          "/api/user/self-service/check-in-out/request/approval/${dataApprovalId!}";
    } else if (dataStatus == "In Progress" || type == "Status") {
      urlApi +=
          "/api/user/self-service/check-in-out/status/${dataType[type]}/${requestId!}";
    } else {
      urlApi =
          "/api/user/self-service/${dataType[type]}/status/my-request/${requestId!}";
    }

    mainService.getUrlHttp(urlApi, true, (res) {
      if (res.statusCode == 200) {
        mainService.hideLoading();
        var data = jsonDecode(res.body);
        setState(() {
          dataDetail = data;
          isSkeletonLoading = false;
          dataApprovalAttachments = data['dataApprovalAttachments'];
          if (dataApprovalAttachments.isNotEmpty) {
            num megaSize = dataApprovalAttachments[0]['size'] / 1000000;
            num megaSizeTemp = megaSize.round();
            num kiloSize = dataApprovalAttachments[0]['size'] / 1000;
            var kiloSizeTemp = kiloSize.round();
            if (megaSize < 1 && megaSize >= 0) {
              dataApprovalAttachments[0]['actualSize'] =
                  kiloSizeTemp.toString() == "0.0" ? "0" : kiloSizeTemp;
              dataApprovalAttachments[0]['actualSizeType'] = "KB";
            } else {
              dataApprovalAttachments[0]['actualSize'] = megaSizeTemp;
              dataApprovalAttachments[0]['actualSizeType'] = "MB";
            }
          }
          if (dataDetail["status"] == "Approved" ||
              dataDetail["status"] == "Rejected" ||
              dataDetail["status"] == "Canceled") {
            isApproved = true;
          } else {
            isApproved = false;
          }
        });
      } else {
        mainService.hideLoading();
        mainService.errorHandlingHttp(res, context);
        setState(() {
          isSkeletonLoading = false;
        });
      }
    });
  }

  getDataHistoryApproval() async {
    String urlApi =
        "${await mainService.urlApi()}/api/user/self-service/check-in-out/request/approval/approval-history/$dataApprovalId";

    randomColor = await mainService.getRandomColor();

    mainService.getUrlHttp(urlApi, true, (res) {
      if (res.statusCode == 200) {
        mainService.hideLoading();
        var data = jsonDecode(res.body);
        setState(() {
          historyApproval = data;
        });
      } else {
        mainService.hideLoading();
        mainService.errorHandlingHttp(res, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map params = ModalRoute.of(context)!.settings.arguments as Map;

    dataStatus = params['dataStatus'];
    type = params['transactionType'];

    dataParams = params['data'];
    requestId = dataParams['requestId'];
    dataApprovalId = dataParams['dataApprovalId'];

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 40,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      selectSegment('Details');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: segmentDetailActive
                              ? BorderSide(
                                  color: '#3DC0F0'.toColor(),
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: Text(
                        'Detail'.toUpperCase(),
                        style: TextStyle(
                          color: segmentDetailActive
                              ? '#3DC0F0'.toColor()
                              : Colors.black45,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      selectSegment('Approval');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: segmentApprovalActive
                              ? BorderSide(
                                  color: '#3DC0F0'.toColor(),
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: Text(
                        'Approval'.toUpperCase(),
                        style: TextStyle(
                          color: segmentApprovalActive
                              ? '#3DC0F0'.toColor()
                              : Colors.black45,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: segmentDetailActive
                  ? Container(
                      height: 550,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: '#F3F3F3'.toColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Request Number',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (isSkeletonLoading)
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            width: double.infinity,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      if (!isSkeletonLoading)
                                        Text(
                                          "${dataDetail['requestNo']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Request Date',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (isSkeletonLoading)
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            width: double.infinity,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      if (!isSkeletonLoading)
                                        Text(
                                          dataDetail['requestDate'] != null
                                              ? DateFormat('dd MMM y HH:mm')
                                                  .format(
                                                      dataDetail['requestDate'])
                                              : '-',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Type',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (isSkeletonLoading)
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            width: double.infinity,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      if (!isSkeletonLoading)
                                        Text(
                                          // dataDetail['type'] != null &&
                                          //         dataDetail['type'] == 'CHECKIN'
                                          //     ? 'Check In - '
                                          //     : 'Check Out - ${(dataDetail['isOutOfOffice'] && dataDetail['isOutOfOffice'] != null) ? 'Out of Office' : 'In Office'}',
                                          "${dataDetail['type'] == 'CHECKIN' ? 'Check In - ' : 'Check Out -'}${(dataDetail['isOutOfOffice'] == true) ? 'Out of Office' : 'In Office'}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Purpose',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (isSkeletonLoading)
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            width: double.infinity,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      if (!isSkeletonLoading)
                                        Text(
                                          "${dataDetail['purpose']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Remark',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (isSkeletonLoading)
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            width: double.infinity,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      if (!isSkeletonLoading)
                                        Text(
                                          "${dataDetail['remarks']}",
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Status',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (isSkeletonLoading)
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            width: double.infinity,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      if (!isSkeletonLoading)
                                        Text(
                                          "${dataDetail['status']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!isSkeletonLoading &&
                                          dataDetail['dataApprovalAttachments']
                                                  .length >
                                              0)
                                        const Text(
                                          'Photo Preview',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      if (isSkeletonLoading)
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            width: double.infinity,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      if (!isSkeletonLoading &&
                                          dataDetail['dataApprovalAttachments']
                                                  .length >
                                              0)
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.6,
                                          height: 50,
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(5.0),
                                              bottomLeft: Radius.circular(5.0),
                                            ),
                                            border: Border.all(
                                                color: '#D0D0D0'.toColor()),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icon/general/picture.svg',
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${dataApprovalAttachments[0]["fileName"]}',
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                          Text(
                                                            '${dataApprovalAttachments[0]["actualSize"]} ${dataApprovalAttachments[0]["actualSizeType"]}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 40,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 13,
                                                  horizontal: 13,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.blue,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icon/general/show-location.svg',
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Location',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (isSkeletonLoading)
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            width: double.infinity,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      if (!isSkeletonLoading)
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Row(
                                            children: [
                                              Container(
                                                // height: 40,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(0),
                                                    bottomRight:
                                                        Radius.circular(0),
                                                  ),
                                                ),
                                                child: Image.asset(
                                                  'assets/image/approval/preview-map.png',
                                                  scale: 1.2,
                                                ),
                                              ),
                                              Container(
                                                height: 38,
                                                width: 30,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 7,
                                                  horizontal: 7,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5.0),
                                                    bottomRight:
                                                        Radius.circular(5.0),
                                                  ),
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icon/general/show-location.svg',
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!isApproved &&
                              segmentValue == 'Details' &&
                              type == 'Status')
                            Container(
                              width: double.infinity,
                              height: 40.0,
                              margin: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : Container(
                      height: 550,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const Text(
                              'Person In Charge',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            children: historyApproval.isNotEmpty
                                ? historyApproval
                                    .map(
                                      (e) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (e['profilePictureUrl'] != null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                e['profilePictureUrl'],
                                                width: 60.0,
                                                height: 60.0,
                                              ),
                                            ),
                                          if (e['profilePictureUrl'] == null)
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
                                          SizedBox(
                                            height: 150,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    100) *
                                                70,
                                            child: Card(
                                              color: '#F3F3F3'.toColor(),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    width:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                100) *
                                                            40,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${e["employeeName"]}',
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${e["employeeNo"] ?? "-"}',
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                                  'dd MMM y HH:mm')
                                                              .format(DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                      e["actionDateTimeMilliSecond"])),
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        const Text(
                                                          'Note:',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${e["actionNote"] ?? "-"}',
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                100) *
                                                            20,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/icon/general/approve.svg'),
                                                        Text(
                                                          '${e["status"]}',
                                                          style: TextStyle(
                                                            color: '00DF16'
                                                                .toColor(),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                    .toList()
                                : [
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Image.asset(
                                          'assets/image/profile/no-data.png'),
                                    ),
                                    const Text(
                                      'No Data Found',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
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
