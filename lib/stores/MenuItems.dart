import 'package:mobx/mobx.dart';
part 'MenuItems.g.dart';

class MenuItems = _MenuItems with _$MenuItems;

abstract class _MenuItems with Store {
  @observable
  String opt = "Most Popular";

  @action
  setOpt(String opt) {
    this.opt = opt;
  }

  @action
  getOpt() {
    return opt;
  }
}
