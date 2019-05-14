import 'package:redux/redux.dart';
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/redux/actions.dart';

//TODO: Eventually get twitter login working.
class LogInViewModel {
  final Function onGoogleSignInPressed;
  final Function onFacebookSignInPressed;
  final Function onTwitterSignInPressed;

  LogInViewModel(
      {this.onGoogleSignInPressed,
      this.onFacebookSignInPressed,
      this.onTwitterSignInPressed});

  factory LogInViewModel.fromStore(Store<AppState> store) {
    return LogInViewModel(
        onGoogleSignInPressed: () => store.dispatch(GoogleSignInAction()),
        onFacebookSignInPressed: () => store.dispatch(FacebookSignInAction()),
        onTwitterSignInPressed: () => store.dispatch(TwitterSignInAction()));
  }
}
