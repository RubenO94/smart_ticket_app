class Device {
  Device({required this.deviceId})
      : isRegistered = false,
        isActivated = false;
  final String deviceId;
  bool isRegistered;
  bool isActivated;
}
