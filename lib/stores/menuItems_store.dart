import 'package:mobx/mobx.dart';
part 'menuItems_store.g.dart';

class MenuItemsStore = _MenuItemsStore with _$MenuItemsStore;

abstract class _MenuItemsStore with Store {
  @observable
  String option = "Most Popular";

  @action
  changeOption(String opt) {
    this.option = opt;
  }

}
