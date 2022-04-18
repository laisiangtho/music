part of data.core;

class Authentication extends UnitAuthentication {
  // Authentication({name, options}) : super(name: name, options: options);
  Authentication()
      : super(
          appleServiceId: 'com.zaideih.app.signin',
          redirectUri: 'https://zaideih-app.firebaseapp.com/__/auth/handler',
        );
}
