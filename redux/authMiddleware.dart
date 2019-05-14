import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/redux/actions.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

//should be done

googleSignIn(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GoogleSignInAction) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credentials = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final FirebaseUser user = await _auth.signInWithCredential(credentials);
      store.dispatch(SignedInAction(user));
      store.dispatch(NavigationAction(route: "/home", dialog: false));
    } catch (err) {
      print(err.toString());
    }
  }
  next(action);
}

facebookSignIn(Store<AppState> store, action, NextDispatcher next) async {
  if (action is FacebookSignInAction) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logInWithReadPermissions(['email']);
      final AuthCredential credentials = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );

      final FirebaseUser user = await _auth.signInWithCredential(credentials);
      store.dispatch(SignedInAction(user));
      store.dispatch(NavigationAction(route: "/home", dialog: false));
    } catch (err) {
      print(err.toString());
    }
  }
  next(action);
}

twitterSignIn(Store<AppState> store, action, NextDispatcher next) async {
  if (action is TwitterSignInAction) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final twitterLogin = TwitterLogin(
        consumerKey: "xxx",
        consumerSecret: "xxx",
      );
      final result = await twitterLogin.authorize();

      final AuthCredential credentials = TwitterAuthProvider.getCredential(
        authToken: result.session.token,
        authTokenSecret: result.session.secret,
      );

      final FirebaseUser user = await _auth.signInWithCredential(credentials);
      store.dispatch(SignedInAction(user));
      store.dispatch(NavigationAction(route: "/home", dialog: false));
    } catch (err) {
      print(err.toString());
    }
  }
  next(action);
}

signOut(Store<AppState> store, action, NextDispatcher next) async {
  if (action is SignOutAction) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final facebookLogin = FacebookLogin();
      final GoogleSignIn _googleSignIn = new GoogleSignIn();

      facebookLogin.logOut();
      _googleSignIn.signOut();
      _auth.signOut();
      store.dispatch(ClearEntriesAction());
      store.dispatch(NavigationAction(route: "/login", dialog: false));
    } catch (err) {
      print(err.toString());
    }
  }
  next(action);
}

loadingAuth(Store<AppState> store, action, NextDispatcher next) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  if (action is LoadingAction) {
    final FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      store.dispatch(SignedInAction(user));
      store.dispatch(NavigationAction(route: "/home", dialog: false));
    } else {
      store.dispatch(NavigationAction(route: "/login", dialog: false));
    }
  }
  next(action);
}
