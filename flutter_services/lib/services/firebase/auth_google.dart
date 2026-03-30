/* Documents and Integration
https://pub.dev/packages/google_sign_in

- Firebase Authentication üzeriden google aktif et.
NOT: Firebase yerine Google Cloud kullanılabilir.

ANDROID:
Firebase üzerinden SHA bilgisi ekledikten sonra google-services.json dosyasını uygulamaya ekleyin.
[project_file]/android> ./gradlew signingReport 	->	SHA1 keyleri verir

IOS:
GoogleService-Info.plist içindeki CLIENT_ID'leri aşağıdaki gibi Info.plist içine kopyalayın.
<!-- Google Sign-in -->
<key>GIDClientID</key>
<string>[YOUR IOS CLIENT_ID]</string>
<!-- Google Sign-in Section -->
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>[YOUR IOS REVERSED_CLIENT_ID]</string>
		</array>
	</dict>
</array>

*/

import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleAuthService instance = GoogleAuthService._internal();
  GoogleAuthService._internal();

  GoogleSignInAccount? currentUser;
  final _instance = GoogleSignIn.instance;

  Future<void> init() async {
    _instance.authenticationEvents
        .listen(_handleAuthenticationEvent)
        .onError(_handleAuthenticationError);
    await _instance.initialize();
  }

  // #region handle
  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    currentUser = user;
  }

  Future<void> _handleAuthenticationError(Object e) async {
    currentUser = null;
  }
  // #endregion

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _instance.authenticate();
    } catch (e) {
      return null;
    }
  }

  Future<bool> signOut() async {
    try {
      await _instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
