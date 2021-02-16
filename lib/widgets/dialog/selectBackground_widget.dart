import 'package:flutter/material.dart';
import 'package:project1/stores/firebase_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SelectBackground extends StatelessWidget {
  final List<String> backgrounds = [
    "background (1).png",
    "background (2).png",
    "background (3).png",
    "background (4).png",
    "background (5).png",
    "background (6).png",
    "background (7).png",
    "background (8).png",
    "background (9).png",
    "background (10).png",
    "background (11).png",
    "background (12).png",
    "background (13).png",
    "background (14).png",
    "background (15).png",
    "background (16).png",
    "background (17).png",
    "background (18).png",
    "background (19).png",
    "background (20).png",
   
  ];
  @override
  Widget build(BuildContext context) {
    final firebaseStore = Provider.of<FirebaseStore>(context);
    final width =MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width:width / 2,
      height: height / 2,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(flex:10,child: Text(translate('dialog_background.set_background'),style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20),)),
        Expanded(
          flex:90,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverList(
                  
                delegate: SliverChildBuilderDelegate(
                  
                  (ctx, index) =>
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: GestureDetector(
                      child:  Container(
                        decoration:BoxDecoration(border: Border.all(width: 3)),
                        height: height * 0.2,child: Image.asset("assets/background/${backgrounds[index]}",fit: BoxFit.fitWidth)),
                      onTap: (){
                        firebaseStore
                          .setBackground("assets/background/${backgrounds[index]}");
                          Navigator.of(context).pop(); },
                  ),
                   ),childCount:backgrounds.length,
                ),
                ),
                  
                  
              
            ],
          ),
        ),
      ]),
    );
  }
}
