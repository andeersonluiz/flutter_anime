import 'package:mobx/mobx.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:project1/support/shared_preferences.dart';

part 'dropdown_store.g.dart';

class DropdownStore = _DropdownStoreBase with _$DropdownStore;

abstract class _DropdownStoreBase with Store {
  
  @observable
  String valueDropdown;
  String valueCode = "en_US";
  SharedPrefs prefs;
  _DropdownStoreBase(){
      prefs = SharedPrefs();

      
  }

  @action
  changeValueDropdown(String newValue)
  {
    if(newValue ==  translate("dialog_settings.english_item")){
        valueDropdown=newValue;
        this.valueCode="en_US";
    }else if(newValue == translate("dialog_settings.portuguese_item")){
        valueDropdown=newValue;
        this.valueCode="pt";
    }
    prefs.persistLanguage(this.valueCode);
  }
  

}