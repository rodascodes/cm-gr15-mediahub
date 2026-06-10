import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/**
 * Serviço de notificações push locais.
 * Gerencia a exibição de notificações no dispositivo.
 */
class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _notifications = FlutterLocalNotificationsPlugin();

  /**
   * Inicializa o serviço de notificações.
   * Configura os parâmetros de notificações do Android.
   */
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);
  }

  /**
   * Exibe uma notificação push local no dispositivo.
   * 
   * @param title O título da notificação
   * @param body O corpo/mensagem da notificação
   */
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'mediahub_channel',
      'MediaHub Notifications',
      channelDescription: 'Notificações da aplicação MediaHub',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
    );
  }
}