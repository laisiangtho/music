# Zaideih@Music

![alt text][logo]

Listen to [Zaideih][webapp]

...at [App Store][appstore],
[Play Store][playStore] or [clone](#how-would-i-clone-correctly), [privacy][privacy].

Zaideih Music Station is a collection of "ethnic" musics as in audio, and aimed to provide a collective information of "unsung artists" as of "unsung hero". A moment in our life, we have acknowledged that a sound of any recordings touched us deep in our soul, and wondered how, when, or why. This is where Zaideih stands to answer at it best within our library "Here it is, what do you think?".

The contents of Zaideih libaray has got many unsung artists and respective copyright owners that were unknown to us to these days or at least to Zaideih. We at Zaideih believed that nothing is magically happened, but experiences, hard work and dedication.

Our aim and objective is to be heard, and make it available around the world these musics. We are hoping to achieve Zaideih can be an oasis where people can be united through their love of music. That is why we wanted to provide a simple solution with free of charge so that anyone may enjoy having their own collection manage playlists, lyrics and comments,

Zaideih has currently:

- catalogs its library
  - [x] Love of the land
  - [x] At mercy
  - [x] Gospel
  - [x] Worship
- in tribe
  - [x] Zomi
  - [x] Mizo
  - [x] Falam

Feature

- search
  - suggestion
- library
- background
- broadcast via bluetooth
- recent searches
- playlists
  - sorting

Zaideih was actually initiated in 2006, but after many advices from friends (_namely: Thang Biak Lal, Paupi, Cinpu_), it's got the name "Zaideih", and launched in 2007 on its own domain name. Ever since Zaideih have been shifted according to technologies such as asp, flash, php, and Node.js for web app. Codova and Phonegap for mobile app. There has been a huge improvement, and one of the biggest was developed using Flutter, which mean running on Multi-platform.

Any concerning data [Privacy & Security][privacy].

![alt text][license]
![alt text][flutterversion]

## Zaideih

In case of wondering what "**Zaideih**" is or means, I would like to give you a hint. Of course it means "_sing proud_" in _zolai_. But what is zolai then? Well its a name of written language using by some folks from Myanmar and India, called themselve as zomi, and their spoken language is zopau/zokam. You may know them as _Chin, Tedim, Falam, Hakha, Paite, Mizo, Kuki_ and many more. Each one of them has their own dialect and tradition like swedish and norwegian, with no country but border seperation. Many of its people speak and understand other dialect. This is where Zaideih app is needed. I have no economic profit on making this app. If you like this particular application and its experience you are much welcome to support in anyway you would like.

We are not just providing builded/packaged app. But opensource that you would have you own making of the Music library.

Take a look: [https://en.wikipedia.org/wiki/Zo_people]

## analytics (debug on windows)

```sh
# cd \dev\android-sdk\platform-tools
cd /dev/android-sdk/platform-tools
adb shell setprop debug.firebase.analytics.app "com.zaideih.app"
```

## How would I clone correctly

All you need is basically a Github command line, flutter, and modify a few settings, such as version, packageName for Android or Bundle Identifier for iOS. Since `com.zaideih.app` has already taken you would need you own. It does not need to be a domain path but just uniqueid, so you should not take "~~com.google~~" or anything that you don't own!

Rename `assets/mock-env.json` to **assets/env.json** and `assets/mock-album.json` to **assets/album.json**.

There isn't an easy way to separate ui and logic in flutter, any related dart scripts that plays primary logic in this application are moved to [lidea repo][lidea] as a seperated package. But they will work the same as bundle scripts.

In `pubspec.yaml` remove local package `lidea` and uncomment git

```yaml
dependencies:
  flutter:
    sdk: flutter
  ...
  # Local lidea package, only in development
  # lidea:
  #   path: ../lidea
  # Github lidea package, uncomments lines below
  lidea:
    git:
      url: git://github.com/laisiangtho/lidea.git
      ref: main
  ...
```

...you will need your own configuration in the following files, for more info please run `flutter doctor` and see if you get it right.

- `android/local.properties`

```sh
sdk.dir       = <android-sdk-path>
flutter.sdk   = <flutter-sdk-path>
```

- `android/key.properties`

```sh
storePassword = <store-file-password>
keyPassword   = <key-file-password>
keyAlias      = <key-alias-name>
storeFile     = <path-of-jks>
```

- `android/app/google-services.json`

This is a JSON formated file, you can get it from `Google console -> IAM & ADMIN -> Service Accounts` or Firebase.

## Build and config

[Android][tool-android], [iOS][tool-ios]

[appstore]: https://apps.apple.com/us/app/zaideih/id1609961412
[playStore]: https://play.google.com/store/apps/details?id=com.zaideih.app
[playStore Join]: https://play.google.com/apps/testing/com.zaideih.app/join

[webapp]: https://www.zaideih.com/
[Home]: https://github.com/laisiangtho/music

[lidea]: https://github.com/laisiangtho/lidea
[tool-android]: https://github.com/laisiangtho/lidea/blob/main/TOOL.md#android
[tool-ios]: https://github.com/laisiangtho/lidea/blob/main/TOOL.md#ios

[privacy]: /PRIVACY.md

[logo]: https://raw.githubusercontent.com/laisiangtho/music/master/music.png "Zaideih"
[license]: https://img.shields.io/badge/License-MIT-yellow.svg "License"
[flutterversion]: https://img.shields.io/badge/flutter-%3E%3D%202.12.0%20%3C3.0.0-green.svg "Flutter version"
