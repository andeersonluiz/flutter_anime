import 'package:flutter/material.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';

class SelectAvatar extends StatelessWidget {
  final List<String> avatars = [
    "avatar (1).jpg",
    "avatar (2).jpg",
    "avatar (3).jpg",
    "avatar (4).jpg",
    "avatar (5).jpg",
    "avatar (6).jpg",
    "avatar (7).jpg",
    "avatar (8).jpg",
    "avatar (9).jpg",
    "avatar (10).jpg",
    "avatar (11).jpg",
    "avatar (12).jpg",
    "avatar (13).jpg",
    "avatar (14).jpg",
    "avatar (15).jpg",
    "avatar (16).jpg",
    "avatar (17).jpg",
    "avatar (18).jpg",
    "avatar (19).jpg",
    "avatar (20).jpg",
    "avatar (21).jpg",
    "avatar (22).jpg",
    "avatar (23).jpg",
    "avatar (24).jpg",
    "avatar (25).jpg",
    "avatar (26).jpg",
    "avatar (27).jpg",
    "avatar (28).jpg",
    "avatar (29).jpg",
    "avatar (30).jpg",
    "avatar (31).jpg",
    "avatar (32).jpg",
    "avatar (33).jpg",
    "avatar (34).jpg",
    "avatar (35).jpg",
    "avatar (36).jpg",
    "avatar (37).jpg",
    "avatar (38).jpg",
    "avatar (39).jpg",
    "avatar (40).jpg",
    "avatar (41).jpg",
    "avatar (42).jpg",
    "avatar (43).jpg",
    "avatar (44).jpg",
    "avatar (45).jpg",
  ];
  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final width =MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width:width / 2,
      height: height / 3,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(flex:10,child: Text("Select Avatar",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20),)),
        Expanded(
          flex:90,
          child: ScrollConfiguration(
            behavior: ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10.0,

                    crossAxisSpacing: 10.0,
                    crossAxisCount: 3
                  ,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    
                    (ctx, index) =>
                     GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: height * 0.038,
                          backgroundImage:
                              AssetImage("assets/avatars/${avatars[index]}"),
                        ),
                      ),
                      onTap: (){
                        firebaseStore
                          .setAvatar("assets/avatars/${avatars[index]}");
                          Navigator.of(context).pop(); },
                    ),childCount:avatars.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
