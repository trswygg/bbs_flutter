import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  TextEditingController emailC = new TextEditingController();
  TextEditingController passwordC = new TextEditingController();
  var _io = Get.put(NetIo(),permanent:true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          size: 30,
          color: Theme.of(context).accentColor,
        ),
        onTap: (){Get.back();},
      ),),
      backgroundColor: Colors.white,
      body: Center(
        child: loginBody(),
      ),
    );
  }

  loginBody() => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[loginHeader(), loginFields()],
    ),
  );

  loginHeader() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      FlutterLogo(
        size: 80.0,
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        "登录以使用全部功能",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        "Sign in to continue",
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );

  loginFields() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
          child: TextField(
            maxLines: 1,
            maxLength: 30,
            controller: emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "请输入邮箱",
              labelText: "Email",
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          child: TextField(
            maxLines: 1,
            obscureText: true,
            maxLength: 30,
            controller: passwordC,
            decoration: InputDecoration(
              hintText: "请输入密码",
              labelText: "Password",
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 150.0),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(10.0),
            shape: StadiumBorder(),
            child: Text(
              "登录",
              style: TextStyle(color: Colors.white,fontSize: 25),
            ),
            color: BBSColors.green,
            onPressed: () async {
              Fluttertoast.showToast(msg: "Login ${emailC.text} : ${passwordC.text}",);
              await _io.login(emailC.text, passwordC.text).then((r) {
                 r==true?Get.offAllNamed('/'):Fluttertoast.showToast(msg: 'Login fail',toastLength: Toast.LENGTH_LONG);
              });
            },
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          "SIGN UP FOR AN ACCOUNT",
          style: TextStyle(color: BBSColors.gray[5]),
        ),
      ],
    ),
  );
}
