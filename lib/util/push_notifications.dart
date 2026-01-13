import 'package:flutter_base/util/common_imports.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<bool> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isPermanentlyDenied) {
      return false;
    } else if (!status.isGranted) {
      status = await Permission.notification.request();
    }
    return status.isGranted;
  }

  Future<bool> requestPhotoLibraryPermission() async {
    var photoLibraryStatus = await Permission.photos.status;
    if (!photoLibraryStatus.isGranted) {
      photoLibraryStatus = await Permission.photos.request();
    }
    return photoLibraryStatus.isGranted;
  }

  Future<bool> requestFileSystemPermission() async {
    var fileSystemStatus = await Permission.manageExternalStorage.status;
    if (!fileSystemStatus.isGranted) {
      fileSystemStatus = await Permission.manageExternalStorage.request();
    }
    return fileSystemStatus.isGranted;
  }

  static Future localNotificationInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          linux: initializationSettingsLinux,
        );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // on tap local notification in foreground
  @pragma('vm:entry-point')
  static Future<void> onNotificationTap(
    NotificationResponse notificationResponse,
  ) async {
    Map<String, dynamic> jsonData = jsonDecode(notificationResponse.payload!);
    // LoginModel? loginModel = await SharedManager.getLoginData();
    ChatMessage message = ChatMessage.fromJson(jsonData);

    // if (loginModel?.data?.user?.role.toString().toLowerCase() == "caretaker") {
    //   if (message.type == "chat") {
    //     if (Globals.isChatOpen == false) {
    //       RouteNavigate().navigateToPush(
    //           Globals.navigatorKey.currentState!.context,
    //           ChatDetailsPage(
    //             profileUrl: message.userProfile,
    //             chatId: message.chatId,
    //             isBlockCareTaker: false,
    //             isBlockUser: false,
    //             userOderID: message.userId,
    //             userOderName: message.senderName,
    //           )
    //       );
    //     }
    //   }
    //   else {
    //     RouteNavigate().navigateToPush(
    //         Globals.navigatorKey.currentContext!,
    //         MonitorVideoCallCaretaker(
    //           appId: Globals.appIdAgora,
    //           channelName: message.chatId,
    //           token: message.token,
    //           uId: int.parse(message.uniqueUid),
    //         )
    //     );
    //   }
    // }
    // else {
    //   if (Globals.isChatOpen == false) {
    //     RouteNavigate().navigateToPush(
    //         Globals.navigatorKey.currentState!.context,
    //         ChatDetailsPage(
    //           profileUrl: message.userProfile,
    //           chatId: message.chatId,
    //           isBlockCareTaker: false,
    //           isBlockUser: false,
    //           userOderID: message.userId,
    //           userOderName: message.senderName,
    //         ));
    //   }
    // }
  }

  static Future<void> clearAllNotifications() async {
    await flutterLocalNotificationsPlugin
        .cancelAll(); // Cancels all shown & pending notifications
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    final DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          categoryIdentifier: "plainCategory",
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
          presentBanner: true,
          presentList: true,
        );
    AndroidNotificationDetails
    androidNotificationDetails = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'notification_icon',
      color: Colors.blue.shade300,
      channelShowBadge: true,
      showWhen: true,
      // styleInformation: (imagePath != null && File(imagePath).existsSync())
      //     ? BigPictureStyleInformation(
      //         FilePathAndroidBitmap(imagePath),
      //         largeIcon: FilePathAndroidBitmap(imagePath),
      //         contentTitle: title,
      //         summaryText: body,
      //       )
      //     : null,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      getUniqueNotificationId(),
      title,
      body,
      notificationDetails,
      payload: jsonEncode(data),
    );
  }

  static int getUniqueNotificationId() {
    var randomNumber = Random();
    var resultOne = randomNumber.nextInt(2000);
    return resultOne;
  }
}

class ChatMessage {
  final String chatId;
  final String uniqueUid;
  final String appId;
  final String userName;
  final String senderName;
  final String type;
  final String title;
  final String message;
  final String userId;
  final String token;
  final String userProfile;

  ChatMessage({
    required this.chatId,
    required this.uniqueUid,
    required this.appId,
    required this.userName,
    required this.senderName,
    required this.type,
    required this.title,
    required this.message,
    required this.userId,
    required this.token,
    required this.userProfile,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      chatId: json['chatId'] ?? '',
      uniqueUid: json['uniqueUid'] ?? '',
      senderName: json['senderName'] ?? '',
      appId: json['appId'] ?? '',
      userName: json['userName'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      userId: json['userId'] ?? '',
      token: json['token'] ?? '',
      userProfile: json['userProfile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderName': senderName,
      'chatId': chatId,
      'uniqueUid': uniqueUid,
      'appId': appId,
      'userName': userName,
      'type': type,
      'title': title,
      'message': message,
      'userId': userId,
      'token': token,
      'userProfile': userProfile,
    };
  }
}
