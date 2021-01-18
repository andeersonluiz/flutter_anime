import 'package:flutter/material.dart';

class DrawerSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Drawer(

          child:SafeArea(
            child: Column(
                children: [
                  Stack(
                    children: [Container(
                      child: Image.asset("assets/no-thumbnail.jpg",fit:BoxFit.fill),
                      color: Colors.white,width: double.infinity,height: height*0.2,),
                    Positioned(
                      left: (width*0.03),
                      top: (height*0.05),
                      child: CircleAvatar(radius:height*0.04 ,)),
                    Positioned(
                      top: (height*0.15),
                      left: (width*0.04),
                      child: Text("Username")),
                    
                    ],),
                  ListTile(title: Text('Animes'),onTap:()=>Navigator.of(context).pushNamed("/"),),
                  ListTile(title: Text('Characters'),onTap:()=>Navigator.of(context).pushNamed("/characterList")),
                  ListTile(title: Text('Categories'),onTap:()=>Navigator.of(context).pushNamed("/categorieList")),
                  ListTile(title: Text('My favorites')),
                  Divider(),
                  ListTile(title: Text('Login')),
                  ListTile(title: Text('Register')),

                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: ListTile(title: Icon(Icons.wb_sunny_outlined)),//filled is wb_sunny
                  ),
                  ),
            
                  ],
              ),
          ),
          
        );
  }
}