# flutter_instagram_auth

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Steps for instagram auth
<li> Run this command to install package</li>

```bash
dart pub add insta_login
```

<li> Then write this code </li>

```dart
//May be it will work, I didn't test it
InstaView(
    instaAppId: '',
    instaAppSecret:
        '',
    redirectUrl: 'https://ayesha-iftikhar.web.app/',  // MAy be she is the creator
    onComplete: (_token, _userid, _username) {
    WidgetsBinding.instance.addPostFrameCallback((
        timeStamp,
    ) {
        setState(() {
        token = _token;
        userid = _userid;
        username = _username;
        });
    });
    },
);
```