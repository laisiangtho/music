// import 'package:flutter/services.dart';

// class MethodChannelZaideih {
//   final MethodChannel _channel;
//   // static final _mainChannel = MethodChannel('com.ryanheise.just_audio.methods');
//   MethodChannelZaideih(String id)
//     : _channel = MethodChannel('abc.$id'),
//       super();

//   MethodChannel get channel => _channel;

//   Future<SetShuffleModeResponse> setEditQueueMode( SetShuffleModeRequest request) async {
//     // return SetShuffleModeResponse.fromMap(
//     //     (await _channel.invokeMethod<Map<dynamic, dynamic>>(
//     //           'setEditQueueMode', request.toMap()))!);
//     return SetShuffleModeResponse.fromMap(request.toMap());
//   }
// }

// /// Information communicated to the platform implementation when setting the
// /// shuffle mode.
// class SetShuffleModeRequest {
//   final ShuffleModeMessage mode;

//   SetShuffleModeRequest({required this.mode});

//   Map<dynamic, dynamic> toMap() => <dynamic, dynamic>{
//         'mode': mode.index,
//       };
// }

// /// Information returned by the platform implementation after setting the
// /// shuffle mode.
// class SetShuffleModeResponse {
//   static SetShuffleModeResponse fromMap(Map<dynamic, dynamic> map) => SetShuffleModeResponse();
// }

// /// The shuffle mode communicated to the platform implementation.
// enum ShuffleModeMessage { none, all }
