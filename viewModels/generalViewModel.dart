import 'package:waterledger/constants/api.dart';
import 'package:waterledger/redux/actions.dart';

class GeneralViewModel {
  final Function onBMCPressed;
  final Function onAddPressed;

  GeneralViewModel({this.onBMCPressed, this.onAddPressed});

  factory GeneralViewModel.fromStore(store) {
    return GeneralViewModel(
        onBMCPressed: () => store.dispatch(OpenURLAction(bmcURL)),
        onAddPressed: () => store.dispatch(
            NavigationAction(route: "/addEntryDialog", dialog: true)));
  }
}
