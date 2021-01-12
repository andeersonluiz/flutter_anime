import 'package:flutter/material.dart';
import 'package:project1/model/anime_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefs{
Future<SharedPreferences> prefs;
SharedPrefs(){
  prefs = SharedPreferences.getInstance();
}
}