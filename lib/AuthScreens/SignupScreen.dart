import 'dart:io';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:volt/Methods/Method.dart';
import 'package:volt/Methods/api_interface.dart';
import 'package:volt/Screens/Choose_Personal_Trainer.dart';
import 'package:volt/Screens/view_personal_trainer.dart';
import 'package:volt/TrainerPackage/all_trainer.dart';
import 'package:volt/Value/CColor.dart';
import 'package:volt/Value/Dimens.dart';
import 'package:volt/Value/SizeConfig.dart';
import 'package:volt/Value/Strings.dart';
import 'package:volt/util/number_format.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:volt/Methods/Pref.dart';
import '../Methods.dart';
import '../Methods/api_interface.dart';
import '../Value/Strings.dart';
import '../lifecycycle.dart';
import 'SuccessScreen.dart';

class SignupScreen extends StatefulWidget {
  final List response;
  final String type;
  final int planIndex;
  final String formType;
  final bool isSingle;
  final bool isEmailError;
  final bool isCityTrue;
  final int memberIndex;
  final Map<String, String> editData;
  final String roleId;
  final String rolePlanId;

  static MyInheritedData of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(MyInheritedData) as MyInheritedData;

  SignupScreen(
      {this.response,
      this.planIndex,
      this.type,
      this.formType,
      this.memberIndex,
      this.editData,
      this.isCityTrue,
      this.isEmailError,
      this.isSingle,
      this.roleId,
      this.rolePlanId});

  @override
  State<StatefulWidget> createState() => SignupState();
}

class SignupState extends State<SignupScreen> {
  String baseImageUrl = 'assets/images/';
  String radioItem = "";
  String radioItemMarital = '';
  bool acceptTerms = false;
  final formKey = GlobalKey<FormState>();

  /// @AuthScreens Controllers
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var middletNameController = TextEditingController();
  var mobileController = TextEditingController();
  var emergencyController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var dobController = TextEditingController();
  var designationController = TextEditingController();
  var workPlaceController = TextEditingController();
  var nationalityController = TextEditingController();
  var aboutUsController = TextEditingController();
  var emiratesController = TextEditingController();
  var addressController = TextEditingController();
  var hotelController = TextEditingController();
  var durationController = TextEditingController();
  List<String> _cities = [
    'Dubai',
    'Sharjah',
    'Abu Dhabi',
    'Ajman',
    'Ras al-khaimah',
//    'Musaffah City',
    'Fujairah City',
//    'Khalifah A City',
//    'Reef AI Fujairah City',
//    'Bani Yas City',
//    'Zayed City',
    'Umm al-Quwain',
  ];
  String selectedCity;
  var selectedTrainer;

  bool _isIos;
  String deviceType = '';
  String roleId;
  var deviceTok = '';

  var fromDate;
  var myDate, sendDate;
  var formatter = new DateFormat("dd/MM/yyyy");
  var sendDateFormat = new DateFormat("yyyy-MM-dd");

  Map<String, String> parms;

  void fromDatePicker() {
    getData();
  }

  String rolePlanId;

  String myField;

  void onMyFieldChange(String newValue) {
    setState(() {
      myField = newValue;
    });
  }

  Future<DateTime> getData() {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(actions: <Widget>[
            CupertinoActionSheetAction(
              child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.black87),
                    ),
                  )),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (myDate != null) {
                    fromDate = formatter.format(myDate);
                    sendDate = sendDateFormat.format(myDate);
                  }
                });
              },
            ),
            Container(
              height: 300.0,
              color: Colors.white,
              child: CupertinoDatePicker(
                use24hFormat: true,
                maximumDate: new DateTime(2019, 12, 30),
                minimumYear: 1920,
                maximumYear: 2019,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime(2018),
                backgroundColor: Colors.white,
                onDateTimeChanged: (dateTime) {
                  myDate = dateTime;
                  // print("$myDate");
//                setState(() {
//                  if (dateTime != null) fromDate = formatter.format(dateTime);
//                });
                },
              ),
            ),
          ]);
        });

//    return showDatePicker(
//        context: context,
//        initialDate: DateTime(2019),
//        firstDate: DateTime(1980),
//        lastDate: DateTime(2020),
//        builder: (BuildContext context, Widget child) {
//          return Theme(
//            data: ThemeData.fallback(),
//            child: child,
//          );
//        });
  }

  @override
  void initState() {
   if (widget.type != null)print("form type "+widget.type);
    rolePlanId = widget.rolePlanId;
    roleId = widget.roleId;
    print("dataNew " + rolePlanId.toString());
    print("dataNew " + roleId.toString());
    print("check index " + widget.editData.toString());
    _isIos = Platform.isIOS;
    deviceType = _isIos ? 'ios' : 'android';

    if (widget.editData != null) {
      print('mydata ${widget.editData}');
      // if (widget.editData.containsKey(FIRSTNAME + "_1")) {
      //   _setData("_1");
      // } else if (widget.editData.containsKey(FIRSTNAME + "_2")) {
      //   _setData("_2");
      // } else if (widget.editData.containsKey(FIRSTNAME + "_3")) {
      //   _setData("_3");
      // } else {
      //   _setData("");
      // }
      _setData(widget.memberIndex.toString());
    }
    getString(fireDeviceToken).then((value) {
      deviceTok = value;
    });
    super.initState();
  }

//  @override
//  void dispose(){
//    firstNameController.dispose();
//    middletNameController.dispose();
//    lastNameController.dispose();
//    mobileController.dispose();
//    emergencyController.dispose();
//    emailController.dispose();
//    passwordController.dispose();
//    designationController.dispose();
//    emiratesController.dispose();
//    addressController.dispose();
//    super.dispose();
//  }
//
  _setData(String ind) {
    print("kjhrfikrhf ${widget.editData}  $ind");
    if (ind == '0') {
      firstNameController.text = widget.editData[FIRSTNAME];
      radioItem = widget.editData[CHILD];
      fromDate = widget.editData[BIRTH_DATE];
      sendDate = widget.editData[BIRTH_DATE];
      middletNameController.text = widget.editData[MIDDLENAME];
      lastNameController.text = widget.editData[LASTNAME];
      mobileController.text = widget.editData[MOBILE];
      emergencyController.text = widget.editData[EMEREGENCY_NUMBER];
      emailController.text = widget.editData[EMAIL];
      passwordController.text = widget.editData[PASSWORD];
      // fromDate = widget.editData[BIRTH_DATE];
      designationController.text = widget.editData[DESIGNATION];
      aboutUsController.text = widget.editData[about_us];
      nationalityController.text = widget.editData[nationality];
      workPlaceController.text = widget.editData[workplace];
      radioItemMarital = widget.editData[marital_status];
      emiratesController.text = widget.editData[EMIRATES_ID];
      addressController.text = widget.editData[ADDRESS];
      selectedCity = widget.editData[CITY];
      selectedTrainer = widget.editData[trainerIds];
      // durationController.text = widget.editData[durationOfStay];
      // hotelController.text = widget.editData[hotelNo];
     // selectedTrainer = widget.editData[trainerIds + '_' + ind];

    } else {
      firstNameController.text = widget.editData[FIRSTNAME + '_' + ind];
      radioItem = widget.editData[CHILD + '_' + ind];
      fromDate = widget.editData[BIRTH_DATE + '_' + ind];
      sendDate = widget.editData[BIRTH_DATE + '_' + ind];
      middletNameController.text = widget.editData[MIDDLENAME + '_' + ind];
      lastNameController.text = widget.editData[LASTNAME + '_' + ind];
      mobileController.text = widget.editData[MOBILE + '_' + ind];
      emergencyController.text = widget.editData[EMEREGENCY_NUMBER + '_' + ind];
      emailController.text = widget.editData[EMAIL + '_' + ind];
      passwordController.text = widget.editData[PASSWORD + '_' + ind];
      // fromDate = widget.editData[BIRTH_DATE + "_$ind"];
      designationController.text = widget.editData[DESIGNATION + '_' + ind];
      emiratesController.text = widget.editData[EMIRATES_ID + '_' + ind];
      addressController.text = widget.editData[ADDRESS + '_' + ind];
      selectedCity = widget.editData[CITY + '_' + ind];
      selectedTrainer = widget.editData[trainerIds + '_' + ind];
      // durationController.text = widget.editData[durationOfStay];
      // hotelController.text = widget.editData[hotelNo];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<File> file;
    //[{id: 1, fee: 250, fee_type: Monthly, role_id: 1, role_plan: Monthly: AED 250},
    // {id: 2, fee: 1700, fee_type: Quarterly, role_id: 1, role_plan: Quarterly: AED 1700},
    // {id: 3, fee: 3200, fee_type: Half yearly, role_id: 1, role_plan: Half yearly: AED 3200},
    // {id: 4, fee: 6000, fee_type: Yearly, role_id: 1, role_plan: Yearly: AED 6000}]

    // [{id: 25, fee: 400, fee_type: Monthly, role_id: 7, role_plan: Monthly: AED 400},
    // {id: 26, fee: 700, fee_type: Quarterly, role_id: 7, role_plan: Quarterly: AED 700},
    // {id: 27, fee: 1300, fee_type: Half yearly, role_id: 7, role_plan: Half yearly: AED 1300},
    // {id: 28, fee: 1900, fee_type: Yearly, role_id: 7, role_plan: Yearly: AED 1900}]
    if (widget.type != null) {
      //  roleId = widget.response[0]['id'].toString();

      if (widget.type != 'guest') {
        List plans = widget.response;
        if (plans.length > 0) {
          //  rolePlanId = plans[widget.planIndex]['id'].toString();
          //   rolePlanId = widget.rolePlanId;
          //   roleId = widget.roleId;
          //roleId = widget.response[widget.planIndex]['role_id'].toString();
        }
      }
    }
    SizeConfig().init(context);
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, widget.editData);
          return new Future(() => false);
        },
        child: Form(
          key: formKey,
          child: Scaffold(
            backgroundColor: CColor.WHITE,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 300.0,
                    floating: false,
                    backgroundColor: Colors.black,
                    pinned: true,
                    iconTheme: IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text("",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          )),
                      background: Container(
                        margin: EdgeInsets.fromLTRB(0, topMargin, 0, 0),
                        height: 300,
                        width: SizeConfig.screenWidth,
                        color: Colors.black,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                                left: 0,
                                right: 0,
                                top: padding50,
                                child: Image.asset(
                                  baseImageUrl + 'exc_sign.png',
                                  height: 111,
                                )),
                            Positioned(
                              left: 50,
                              bottom: padding50 + padding30,
                              child:
                                  Image.asset(baseImageUrl + 'user_sign.png'),
                            ),
                            Positioned(
                              left: 90,
                              bottom: padding50 + padding30,
                              child: Text(
                                signup,
                                style: TextStyle(
                                    color: CColor.WHITE, fontSize: textSize24),
                              ),
                            ),
                            Positioned(
                              //top: ,
                              left: 90,
                              right: 60,
                              bottom: 20,
                              child: Padding(
                                child: Text(
                                  'Please give us your details to enjoy our premium experience',
                                  style: TextStyle(
                                      color: CColor.WHITE,
                                      fontSize: textSize12),
                                ),
                                padding: EdgeInsets.fromLTRB(5, 10, 20, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          padding50, padding30, padding50, padding30),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Enter your personal details below: ',
                            style: TextStyle(
                                color: Color(0xFF707070), fontSize: 15),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter(
                                    RegExp("[a-zA-Z]"))
                              ],
                              validator: (value) {
                                if (value.isEmpty) {
                                  return fieldIsRequired;
                                }
                                return null;
                              },
                              controller: firstNameController,
                              decoration: InputDecoration(
                                  hintText: firstname + '*',
                                  hintStyle: TextStyle(fontSize: textSize12)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter(
                                    RegExp("[a-zA-Z]"))
                              ],
                              controller: middletNameController,
                              decoration: InputDecoration(
                                  hintText: midlename,
                                  hintStyle: TextStyle(fontSize: textSize12)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                // ignore: deprecated_member_use
                                WhitelistingTextInputFormatter(
                                    RegExp("[a-zA-Z]"))
                              ],
                              validator: (value) {
                                if (value.isEmpty) {
                                  return fieldIsRequired;
                                }
                                return null;
                              },
                              controller: lastNameController,
                              decoration: InputDecoration(
                                  hintText: lastname + '*',
                                  hintStyle: TextStyle(fontSize: textSize12)),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Visibility(
                            visible: widget.type != 'fairMont',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                radiobutton('Male'),
                                radiobutton('Female'),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: widget.type != 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  // ignore: deprecated_member_use
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  CardNumberInputFormatter()
                                ],
                                maxLength: 15,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return fieldIsRequired;
                                  } else if (value.length < 9) {
                                    return 'Please Enter Valid Number';
                                  }
                                  return null;
                                },
                                controller: mobileController,
                                decoration: InputDecoration(
                                    hintText: mobile,
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: (widget.memberIndex == 0 || widget.memberIndex == null) && widget.type != 'guest' && widget.type != 'fairMont',
                              child: Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    // ignore: deprecated_member_use
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    CardNumberInputFormatter()
                                  ],
                                  maxLength: 15,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return fieldIsRequired;
                                    } else if (value.length < 9) {
                                      return 'Please enter valid number';
                                    }
                                    return null;
                                  },
                                  controller: emergencyController,
                                  decoration: InputDecoration(
                                      hintText: emergencyContact,
                                      hintStyle:
                                          TextStyle(fontSize: textSize12)),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return fieldIsRequired;
                                } else if (!validateEmail(value)) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                              controller: emailController,
                              decoration: InputDecoration(
                                  hintText: email + '*',
                                  hintStyle: TextStyle(fontSize: textSize12)),
                            ),
                          ),
                          Visibility(
                            visible: widget.type != 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return fieldIsRequired;
                                  } else if (value.length < 5) {
                                    return 'Password must be more than 6 words';
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: password + '*',
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.type != 'fairMont',
                            child: Container(
                              margin: EdgeInsets.only(top: margin20, bottom: 10),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(button_radius)),
                                  border: Border.all(
                                      color: Colors.black26, width: 1)),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        fromDate == null
                                            ? birthDate
                                            : fromDate.toString(),
                                        style: TextStyle(
                                            fontSize: textSize12,
                                            color: fromDate == null
                                                ? Colors.black45
                                                : Colors.black),
                                      )),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: fromDatePicker,
                                    child: Container(
                                      height: 50,
                                      width: 40,
                                      color: Color(0xFFDFDFDF),
                                      child: Image(
                                        image: AssetImage(
                                            baseImageUrl + 'calendar.png'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.memberIndex == 0 || widget.memberIndex == null && widget.type != 'fairMont',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                radioMerital(single),
                                radioMerital(married),
                              ],
                            ),
                          ),
                          Visibility(
                            visible:(widget.memberIndex == 0 || widget.memberIndex == null) && widget.type != 'guest' && widget.type != 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: designationController,
                                decoration: InputDecoration(
                                    hintText: designation,
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),
                          Visibility(
                          visible: widget.type == 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: hotelController,
                                decoration: InputDecoration(
                                    hintText: "Hotel Room Number",
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),Visibility(
                            visible: widget.type == 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: durationController,
                                decoration: InputDecoration(
                                    hintText: "Duration of Stay",
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible:(widget.memberIndex == 0 || widget.memberIndex == null) && widget.type != 'guest'&& widget.type != 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: aboutUsController,
                                decoration: InputDecoration(
                                    hintText: "How did you hear about us",
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible:(widget.memberIndex == 0 || widget.memberIndex == null) && widget.type != 'guest'&& widget.type != 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: nationalityController,
                                decoration: InputDecoration(
                                    hintText: "Nationality",
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (widget.memberIndex == 0 || widget.memberIndex == null) && widget.type != 'guest' && widget.type != 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: workPlaceController,
                                decoration: InputDecoration(
                                    hintText: "Work place",
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (widget.memberIndex == 0 || widget.memberIndex == null) && widget.type != 'guest',
                            child: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return fieldIsRequired;
                                  }
                                  return null;
                                },
                                controller: emiratesController,
                                decoration: InputDecoration(
                                    hintText: emiratesId,
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible:(widget.memberIndex == 0 || widget.memberIndex == null) && widget.type != 'guest' && widget.type != 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return fieldIsRequired;
                                  }
                                  return null;
                                },
                                controller: addressController,
                                decoration: InputDecoration(
                                    hintText: address,
                                    hintStyle: TextStyle(fontSize: textSize12)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (widget.memberIndex == 0 || widget.memberIndex == null) && widget.type != 'guest'&& widget.type != 'fairMont',
                            child: Padding(
                                padding: EdgeInsets.only(top: 18),
                                child: DropdownButton(
                                  hint: selectedCity == null
                                      ? Text('Select Emirates')
                                      : Text(
                                          selectedCity,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                  isExpanded: true,
                                  iconSize: 30.0,
                                  style: TextStyle(fontSize: 12),
                                  items: _cities.map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(
                                          val,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    setState(
                                      () {
                                        selectedCity = val;
                                      },
                                    );
                                  },
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: mediaHeight * 0.07,
                                width: mediaHeight * 0.30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: file == null
                                      ? Text('Choose File to Upload')
                                      : Text("Files Selected"),
                                ),
                              ),
                              SizedBox(
                                width: mediaWidth * 0.06,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                height: mediaHeight * 0.06,
                                width: mediaWidth * 0.15,
                                child: RaisedButton.icon(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 2),
                                  onPressed: () {
                                    setState(() async {
                                    //  FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);
                                      if (result != null) {
                                        setState(() {
                                          // file = result.paths
                                          //     .map((path) => File(path))
                                          //     .toList();
                                        });
                                      }
                                    });
                                  },
                                  icon: Center(child: Icon(Icons.filter)),
                                  label: Text(""),
                                ),
                              ),
                            ],
                          ),

                          Visibility(
                          visible:widget.type != 'fairMont',
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Text("Choose Trainer"),
                                  Spacer(),
                                  InkWell(
                                    onTap: () =>
                                        _navigateAndDisplaySelection(context),
                                        child: result != null
                                        ? Text(
                                            "Change",
                                            style:
                                                TextStyle(color: Colors.indigo),
                                          )
                                        : Container(
                                            child: Center(
                                                child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            )),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Colors.black),
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: result != null,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Card(
                                color: Color(0xffF8F8F8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            result != null
                                                ? result[0]["full_name"]
                                                : "Farley Willth",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            result != null
                                                ? result[0]["expirence"]
                                                : "7 Years Experienced",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                              "${result != null ? result[0]["booking_cnt"] : "0"} Trainees (${result != null ? result[0]["booking_reviewed_cnt"] : "0"} Reviews)",
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          Text(
                                              "Session Period - ${result != null ? result[1] : "0"} Hours",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Trainer Price -  ${result != null && result.length > 2 ? result[2].toString() : "0"} AED",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                          "assets/images/vector.png"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Visibility(
                          //   visible: widget.formType.isEmpty ? true : false,
                          //   child: Padding(
                          //       padding: EdgeInsets.only(top: 18),
                          //       child: DropdownButton(
                          //         hint: selectedCity == null
                          //             ? Text('Select Trainer') : Text(selectedCity,
                          //           style: TextStyle(fontSize: 12),
                          //               ),
                          //         isExpanded: true,
                          //         iconSize: 30.0,
                          //         style: TextStyle(fontSize: 12),
                          //         items: _cities.map(
                          //           (val) {
                          //             return DropdownMenuItem<String>(
                          //               value: val,
                          //               child: Text(
                          //                 val,
                          //                 style: TextStyle(color: Colors.black),
                          //               ),
                          //             );
                          //           },
                          //         ).toList(),
                          //         onChanged: (val) {
                          //           setState(
                          //             () {
                          //               selectedCity = val;
                          //             },
                          //           );
                          //         },
                          //       )),
                          // ),
                          Visibility(
                              visible: widget.isSingle,
                              child: checkbox(
                                  iaccept, termsofService, acceptTerms)),
                          Container(
                            margin: EdgeInsets.only(top: padding25),
                            height: button_height,
                            width: SizeConfig.screenWidth,
                            child: RaisedButton(
                              onPressed: () {
                                // parms = {
                                //   "trainerPrice": result != null && result.length > 2 ? result[2].toString() : "0",
                                //   if (widget.memberIndex != null)"memberIndex": widget.memberIndex.toString(),
                                //   FIRSTNAME: firstNameController.text.toString().trim(),
                                //   MIDDLENAME: middletNameController.text.toString().trim(),
                                //   LASTNAME: lastNameController.text.toString().trim(),
                                //   CHILD: radioItem,
                                //   MOBILE: mobileController.text.toString().trim(),
                                //   EMAIL: emailController.text.toString().trim(),
                                //   PASSWORD: passwordController.text.toString().trim(),
                                //   BIRTH_DATE: sendDate,
                                //   EMIRATES_ID: emiratesController.text.toString().trim(),
                                //   if (widget.isSingle)ROLE_ID: rolePlanId.toString(),
                                //   if (widget.isSingle && roleId != null)ROLE_PLAN_ID: roleId.toString(),
                                //   EMEREGENCY_NUMBER: emergencyController.text.toString().trim(),
                                //   DESIGNATION: designationController.text.toString().trim(),
                                //   ADDRESS: addressController.text.toString().trim(),
                                //   CITY: selectedCity,
                                //   DEVICE_TYPE: deviceType,
                                //   GENDER: radioItem.toLowerCase(),
                                //   DEVICE_TOKEN: "deviceTok",
                                //   nationality: nationalityController.text,
                                //   workplace: workPlaceController.text,
                                //   marital_status: radioItemMarital.toLowerCase(),
                                //   about_us: aboutUsController.text,
                                //   trainer_id : result != null ? result[0]["id"].toString() : "",
                                //   trainer_slot : result != null ? result[1].toString() : "",
                                //   if(widget.type == 'fairMont') durationOfStay: durationController.text,
                                //   if(widget.type == 'fairMont') hotelNo: hotelController.text,
                                // };
                             //   print("$parms");
//                                _buildMagnifierScreen();

                              //  print("$fromDate");
                                    print("check");
              if (formKey.currentState.validate()) {

                  if( widget.type != 'fairMont' && fromDate == null ){showDialogBox(context, 'Date of Birth', 'Please fill your date of birth');
                  }
                  else if (radioItem.isEmpty && widget.type != 'fairMont') {showDialogBox(context, 'Gender', 'Please select gender');
                  }
                  else if (((widget.memberIndex == 0 || widget.memberIndex == null) && selectedCity == null && widget.type != 'fairMont' && widget.type != "guest")) {showDialogBox(context, 'City', 'Please select your city');

                  }
                  else if (widget.isSingle && !acceptTerms) {
                    showDialogBox(context, termsofService, 'Please read & accept our terms of services');
                  } else
                    {if (widget.memberIndex == 0 || widget.memberIndex == null) {
                    print("check form chekc2");
                    parms = {
                      "trainerPrice": result != null && result.length > 2 ? result[2].toString() : "0",
                      if (widget.memberIndex != null)"memberIndex": widget.memberIndex.toString(),
                      FIRSTNAME: firstNameController.text.toString().trim(),
                      MIDDLENAME: middletNameController.text.toString().trim(),
                      LASTNAME: lastNameController.text.toString().trim(),
                      CHILD: radioItem,
                      MOBILE: mobileController.text.toString().trim(),
                      EMAIL: emailController.text.toString().trim(),
                      PASSWORD: passwordController.text.toString().trim(),
                      BIRTH_DATE: sendDate,
                      EMIRATES_ID: emiratesController.text.toString().trim(),
                      if (widget.isSingle)ROLE_ID: rolePlanId.toString(),
                      if (widget.isSingle && roleId != null)ROLE_PLAN_ID: roleId.toString(),
                      EMEREGENCY_NUMBER: emergencyController.text.toString().trim(),
                      DESIGNATION: designationController.text.toString().trim(),
                      ADDRESS: addressController.text.toString().trim(),
                      CITY: selectedCity,
                      DEVICE_TYPE: deviceType,
                      GENDER: radioItem.toLowerCase(),
                      DEVICE_TOKEN: "deviceTok",
                      nationality: nationalityController.text,
                      workplace: workPlaceController.text,
                      marital_status: radioItemMarital.toLowerCase(),
                      about_us: aboutUsController.text,
                      trainer_id : result != null ? result[0]["id"].toString() : "",
                      trainer_slot : result != null ? result[1].toString() : "",
                      if(widget.type == 'fairMont') durationOfStay: durationController.text,
                      if(widget.type == 'fairMont') hotelNo: hotelController.text,
                    };
                    print("vikas 0=====>${parms.toString()}");
                  }

                  else {
                    parms = {
                      "trainerPrice": result != null && result.length > 2 ? result[2].toString() : "0",
                      "memberIndex": widget.memberIndex.toString(),
                      FIRSTNAME + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': firstNameController.text.toString().trim(),//first_name_1
                      MIDDLENAME + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': middletNameController.text.toString().trim(),
                      LASTNAME + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': lastNameController.text.toString().trim(),
                      CHILD + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': radioItem,
                      MOBILE + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': mobileController.text.toString().trim(),
                      EMAIL + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': emailController.text.toString().trim(),
                      PASSWORD + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': passwordController.text.toString().trim(),
                      BIRTH_DATE + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': sendDate,
                      EMIRATES_ID + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': emiratesController.text.toString().trim(),
                      EMEREGENCY_NUMBER: emergencyController.text.toString().trim(),
                      DESIGNATION: designationController.text.toString().trim(),
                      trainer_id + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': result != null ? result[0]["id"].toString() : "",
                      trainer_slot + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': result != null ? result[1].toString() : "",
                      ADDRESS + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': addressController.text.toString().trim(),
                      CITY: selectedCity,
                      DEVICE_TYPE: deviceType,
                      GENDER + '${widget.memberIndex == 0 ? "" : "_${widget.memberIndex}"}': radioItem.toLowerCase(),
                      DEVICE_TOKEN: "deviceTok",
                      if (widget.memberIndex == 0)nationality: nationalityController.text,
                      if (widget.memberIndex == 0) workplace: workPlaceController.text,
                      if (widget.memberIndex == 0)marital_status: radioItemMarital.toLowerCase(),
                      if (widget.memberIndex == 0)about_us: aboutUsController.text,
                      if(widget.type == 'fairMont') durationOfStay: durationController.text,
                      if(widget.type == 'fairMont') hotelNo: hotelController.text,
                      //  if ( widget.type)about_us: aboutUsController.text,
                      //    if (widget.memberIndex == 0)about_us: aboutUsController.text,
                    };
                    print("vikas 00=====>${parms.toString()}");
                  }
                }
                  if (widget.isSingle) {

                                      // print("vikas 1=====>${parms.toString()}");

                                      isConnectedToInternet().then((internet) {
                                       showProgress(context, "Please wait.....");
                                        if (internet != null && internet) {
                                          signUpToServer(parms)
                                              .then((response) {
                                            dismissDialog(context);
                                            if (response.status) {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                ScaleRoute(
                                                    page: SuccessScreen()),
                                                (r) => false,
                                              );
                                            } else {
                                              var errorMessage = '';
                                              if (response.error != null) {
                                                errorMessage =
                                                    response.error.toString();
                                              } else if (response.errors !=
                                                  null) {
                                                errorMessage = response
                                                    .errors.email
                                                    .toString();
                                              }
                                              showDialogBox(context, "Error!",
                                                  errorMessage);
                                            }
                                          });
                                        } else {
                                          showDialogBox(context, internetError,
                                              pleaseCheckInternet);
                                          dismissDialog(context);
                                        }
                                        dismissDialog(context);
                                      });
                                    } else {
                                      print("Vikas  ${parms.toString()}");
                                      Navigator.pop(context, parms);
                                    }
                                  }else{
                print("Something went wrong");
              }
                                },
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(button_radius)),
                              child: Text(
                                widget.isSingle ? signup : 'Save Details',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget myText(String hint, bool isNumber) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: TextField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
            hintText: hint, hintStyle: TextStyle(fontSize: textSize10)),
      ),
    );
  }

  Widget radiobutton(String title) {
    return Expanded(
      child: RadioListTile(
        groupValue: radioItem,
        activeColor: Colors.black,
        title: Text(
          title,
          style: TextStyle(fontSize: 10),
        ),
        value: title,
        onChanged: (val) {
          setState(() {
            radioItem = val;
          });
        },
      ),
    );
  }

  Widget radioMerital(String title) {
    return Expanded(
      child: RadioListTile(
        groupValue: radioItemMarital,
        activeColor: Colors.black,
        title: Text(
          title,
          style: TextStyle(fontSize: 12),
        ),
        value: title,
        onChanged: (val) {
          setState(() {
            radioItemMarital = val;
            print("${radioItemMarital.toLowerCase()}");
          });
        },
      ),
    );
  }

  Widget checkbox(String title, String richTExt, bool boolValue) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.black,
            value: boolValue,
            onChanged: (bool value) {
              setState(() {
                acceptTerms = value;
                if (value) {
                  // getTerms();
                }
              });
            },
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: new RichText(
                text: new TextSpan(
                  text: title,
                  style: TextStyle(fontSize: textSize10, color: Colors.black),
                  children: <TextSpan>[
                    new TextSpan(
                        text: richTExt,
                        style: TextStyle(
                            fontSize: textSize10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))
                  ],
                ),
              ),
            ),
            onTap: () {
              getTerms();
            },
          ),
        ],
      ),
    );
  }

  void getTerms() async {
    isConnectedToInternet().then((internet) {
      if (internet != null && internet) {
        showProgress(context, "Please wait.....");

        getTermsApi().then((response) {
          dismissDialog(context);
          if (response.status) {
            if (response.data != null) {
              if (response.data.config != null &&
                  response.data.config.isNotEmpty)
                termsBottom('Terms & Conditions', response.data.config);
            }
          } else {
            dismissDialog(context);
            if (response.error != null)
              showDialogBox(context, "Error!", response.error);
          }
        });
      } else {
        showDialogBox(context, internetError, pleaseCheckInternet);
        dismissDialog(context);
      }
    });
  }

  void termsBottom(String title, String msg) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: Container(
              color: Colors.transparent,
              //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(50.0),
                          topRight: const Radius.circular(50.0))),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        child: Padding(
                          child: Align(
                            child: Icon(Icons.close),
                            alignment: Alignment.topRight,
                          ),
                          padding: EdgeInsets.all(15),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Html(data: msg),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 25, bottom: 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                baseImageAssetsUrl + 'logo_black.png',
                                height: 90,
                                color: Color(0xff8B8B8B),
                                width: 120,
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(left: 25, bottom: 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SvgPicture.asset(
                                baseImageAssetsUrl + 'vector_lady.svg',
                                height: 90,
                                width: 120,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, bottom: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              volt_rights,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff8B8B8B),
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: open_italic),
                            )),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  )),
            ));
          });
        });
  }

  List result;

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => ChoosePersonalTrainer()),
    );

    if (result != null) {
      print("$result");
    }
    setState(() {});
  }
}
