import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class MyAboutTile extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final String LICENSE="""
              DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.
  """;
  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      applicationIcon: FlutterLogo(
      ),
      icon: FlutterLogo(
      ),
      aboutBoxChildren: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          "trswygg@gmail.com",
        ),
        Text("OS:${Platform.operatingSystem} v:${Platform.operatingSystemVersion}"),
        Text("Version:${Platform.version}"),
        TextButton(onPressed: () {}, child: Text(
          "Do What The Fuck You Want To Public License",
        )),
      ],
      applicationName: "BBS",
      applicationVersion: "1.0.1",
      applicationLegalese: "WTFPL",
    );
  }
}
