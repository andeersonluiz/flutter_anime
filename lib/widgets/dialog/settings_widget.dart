import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:project1/stores/dropdown_store.dart';
import 'package:flutter_translate/flutter_translate.dart';

class Settings extends StatelessWidget {
  final locations = [
    translate("dialog_settings.english_item"),
    translate("dialog_settings.portuguese_item")
  ];
  final dropdownValue = "English";
  final dropdownStore = DropdownStore();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              translate('dialog_settings.language'),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Observer(builder: (_) {
              return DropdownButton(
                  isExpanded: true,
                  value: dropdownStore.valueDropdown,
                  hint: Center(
                      child:
                          Text(translate('dialog_settings.select_language'))),
                  items: locations.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(child: Text(value)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    return dropdownStore.changeValueDropdown(value);
                  });
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text(translate('dialog_settings.confirm')),
              onPressed: () {
                Navigator.of(context).pop();

                changeLocale(context, dropdownStore.valueCode);
              },
            ),
          )
        ],
      ),
    );
  }
}
