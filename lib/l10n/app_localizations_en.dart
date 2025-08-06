// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get accountInformation => 'Account Information';

  @override
  String get systemInformation => 'System Information';

  @override
  String get userId => 'User ID';

  @override
  String get role => 'Role';

  @override
  String get status => 'Status';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get verifiedEmail => 'Verified Email';

  @override
  String get already => 'Already';

  @override
  String get notYet => 'Not yet';

  @override
  String get lastLogin => 'Last Login';

  @override
  String get madeIn => 'Made In';

  @override
  String get updatedOn => 'Updated On';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmationTitle => 'Logout Confirmation';

  @override
  String get logoutConfirmationMessage =>
      'Are you sure you want to log out of this account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmLogout => 'Logout';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get username => 'Username';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String pleaseEnterField(Object field) {
    return 'Please enter $field';
  }

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get loading => 'Loading...';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get profile => 'Profile';

  @override
  String get device => 'Device';

  @override
  String get addDevice => 'Add Device';

  @override
  String get deviceList => 'Device List';

  @override
  String get security => 'Security';

  @override
  String get changePassword => 'Change Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get completeAccountInfo => 'Complete\naccount information';

  @override
  String get nameLabel => 'Name';

  @override
  String get phoneLabel => 'No. Hp';

  @override
  String get emailLabel => 'Email';

  @override
  String get addressLabel => 'Address';

  @override
  String get signUp => 'Sign up';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get currentPasswordLabel => 'Current Password';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmNewPasswordLabel => 'Confirm New Password';

  @override
  String fieldRequired(Object field) {
    return 'Please enter $field';
  }

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get passwordMismatch => 'New password and confirmation do not match';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordHeader => 'Forgot password?';

  @override
  String get forgotPasswordDescription =>
      'We will send a link to reset your password to your email.';

  @override
  String get send => 'Send';

  @override
  String get signInTitle => 'Sign In';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signInButton => 'Sign in';

  @override
  String get noAccountText => 'Don\'t have an account yet?';

  @override
  String get signUpLink => 'Sign up';

  @override
  String get signUpTitle => 'Sign Up';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get nextButton => 'Next';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signInLink => 'Sign in';

  @override
  String get allFieldsRequired => 'All fields required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get smartHomeTitle => 'Smart Home';

  @override
  String get smartHomeSubtitle => 'Control your smart devices';

  @override
  String get deviceControl => 'Device Control';

  @override
  String get noControlDeviceTitle => 'You don\'t have a control device';

  @override
  String get noControlDeviceSubtitle => 'Please add a control device first.';

  @override
  String get quickScenes => 'Quick Scenes';

  @override
  String get allOn => 'All On';

  @override
  String get allOff => 'All Off';

  @override
  String get statusOn => 'ON';

  @override
  String get statusOff => 'OFF';

  @override
  String activeDevices(Object count) {
    return '$count Active';
  }

  @override
  String get addDeviceTitle => 'Add New Device';

  @override
  String get deviceNameLabel => 'Device Name';

  @override
  String get deviceIdLabel => 'Device ID';

  @override
  String get deviceTypeLabel => 'Device Type';

  @override
  String get deviceBuildingLabel => 'Building';

  @override
  String get installationDateLabel => 'Installation Date';

  @override
  String get selectDateText => 'Select Date';

  @override
  String get saveDeviceButton => 'SAVE DEVICE';

  @override
  String get pleaseSelectDeviceType => 'Please select device type';

  @override
  String get pleaseSelectInstallationDate => 'Please select installation date';

  @override
  String get deviceAddedSuccess => 'Device added successfully';

  @override
  String deviceAddError(Object error) {
    return 'Error: $error';
  }

  @override
  String get deviceListTitle => 'Device List';

  @override
  String get noDevices => 'No devices available';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deviceId => 'Device ID';

  @override
  String get deviceType => 'Type';

  @override
  String get deviceBuilding => 'Building';

  @override
  String get installationDate => 'Installation Date';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get statusMaintenance => 'Maintenance';

  @override
  String get deleteDeviceTitle => 'Delete Device';

  @override
  String deleteDeviceConfirm(Object deviceName) {
    return 'Are you sure you want to delete device $deviceName?';
  }

  @override
  String deleteDeviceSuccess(Object deviceName) {
    return 'Device $deviceName deleted successfully';
  }

  @override
  String deleteDeviceError(Object error) {
    return 'Failed to delete device: $error';
  }

  @override
  String get confirmDelete => 'Delete';

  @override
  String get editDeviceTitle => 'Edit Device';

  @override
  String get deviceStatusLabel => 'Status';

  @override
  String get deviceSaveButton => 'SAVE CHANGES';

  @override
  String get deviceUpdatedSuccess => 'Device updated successfully';

  @override
  String deviceUpdateError(Object error) {
    return 'Failed to update: $error';
  }

  @override
  String get userGuideTitle => 'Smart Power Management Application Usage Guide';

  @override
  String get introTitle => '1. Introduction';

  @override
  String get introContent =>
      'Smart Power Management is an application to monitor and control electrical systems efficiently. Make sure you have a stable internet connection for optimal performance.';

  @override
  String get installTitle => '2. Installation and Preparation';

  @override
  String get downloadTitle => 'Download and Install the App';

  @override
  String get downloadContent =>
      'Download Smart Power Management on Google Play Store or Apple Store. Make sure the device has enough storage space.';

  @override
  String get internetTitle => 'Internet Connection';

  @override
  String get internetContent =>
      'Make sure the device is connected to a stable internet connection to ensure the application works properly.';

  @override
  String get monitoringTitle => '3. Add Monitoring Device';

  @override
  String get openMonitoringTitle => 'Open the Monitoring Menu';

  @override
  String get openMonitoringContent =>
      'On the main page of the application, select the Monitoring menu.';

  @override
  String get addMonitoringDeviceTitle => 'Add New Device';

  @override
  String get addMonitoringDeviceContent =>
      'Press the (+) icon, then enter the device ID and password provided by the technician.';

  @override
  String get controllingTitle => '4. Connecting Control Devices';

  @override
  String get openControllingTitle => 'Open the Controlling Menu';

  @override
  String get openControllingContent =>
      'From the main page, select the Controlling menu to start connecting control devices.';

  @override
  String get addControllingDeviceContent =>
      'Enter device information such as name, IP address, and access code correctly.';

  @override
  String get tipsTitle => '5. Tips and Troubleshooting';

  @override
  String get cannotConnectTitle => 'Device Cannot Connect';

  @override
  String get cannotConnectContent =>
      'Make sure the ID and Password entered are correct, and the device is in pairing mode.';

  @override
  String get supportTitle => 'Technical Support';

  @override
  String get supportContent =>
      'If you experience any issues, please contact customer service via the in-app technical support feature.';

  @override
  String get closingMessage =>
      'Welcome to use Smart Power Management for smarter and more efficient electricity management!';

  @override
  String homeWelcomeTitle(Object name) {
    return 'Welcome\n$name!';
  }

  @override
  String get homeIntroText => 'Let\'s start stabilizing our power output!';

  @override
  String get homeMenuMonitoring => 'Monitoring';

  @override
  String get homeMenuControlling => 'Controlling';

  @override
  String get homeMenuAccount => 'Account';

  @override
  String get homeMenuUserGuide => 'User Guide';

  @override
  String get monitorHeaderTitle => 'Monitor your electricity\nconsumption!';

  @override
  String get monitorHistoryButton => 'View Data History';

  @override
  String get monitorDeviceUnavailableTitle =>
      'Monitoring device is not available';

  @override
  String get monitorDeviceUnavailableDesc =>
      'Please register your monitoring device first to access this feature.';

  @override
  String get monitorLiveTitle => 'Live Monitoring Data';

  @override
  String get monitorPredictionDropdownLabel => 'Prediction Option:';

  @override
  String get monitorChartVoltageCurrent => 'Voltage & Current';

  @override
  String get monitorChartPowerEnergy => 'Power & Energy';

  @override
  String get monitorChartFreqPf => 'Frequency & Power Factor';

  @override
  String get monitorChartTempHumidity => 'Temperature & Humidity';

  @override
  String monitorDatetimeWIB(Object date, Object time) {
    return '$date : $time WIB';
  }

  @override
  String get monitorMetricVoltage => 'Voltage';

  @override
  String get monitorMetricCurrent => 'Current';

  @override
  String get monitorMetricPower => 'Power';

  @override
  String get monitorMetricEnergy => 'Energy';

  @override
  String get monitorMetricFrequency => 'Frequency';

  @override
  String get monitorMetricPowerFactor => 'Power Factor';

  @override
  String get monitorMetricTemp => 'Temp';

  @override
  String get monitorMetricHumidity => 'Humidity';

  @override
  String get welcomeGetStarted => 'Get Started';

  @override
  String get welcomeSignUp => 'Sign up';

  @override
  String get welcomeSignIn => 'Sign in';

  @override
  String get emailRequired => 'Email is required.';

  @override
  String get linkSentSuccess => 'Reset link has been sent to your email.';

  @override
  String get linkSentFailed =>
      'Failed to send reset link. Please try again later.';

  @override
  String get emailVerified => 'Email Verified';

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get emailAlreadyVerified => 'Your email is already verified';

  @override
  String get enterVerificationCodeSentToEmail =>
      'Enter the 6-digit verification code sent to your email.';

  @override
  String get pleaseEnter6DigitCode => 'Please enter a 6-digit code';

  @override
  String get emailSuccessfullyVerified => 'Email successfully verified!';

  @override
  String get verificationFailed => 'Verification failed';

  @override
  String get verificationCodeResent => 'Verification code resent';

  @override
  String get failedToResendCode => 'Failed to resend code';

  @override
  String get verify => 'Verify';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get activeStatus => 'Active';

  @override
  String get inactiveStatus => 'Inactive';

  @override
  String get predictionDataNotAvailable => 'Prediction data not available';

  @override
  String get energyPrediction => 'Energy Prediction';

  @override
  String get dailyPrediction => 'Daily Prediction';

  @override
  String get monthlyPrediction => 'Monthly Prediction';

  @override
  String get yearlyPrediction => 'Yearly Prediction';

  @override
  String get date => 'Date';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get averagePowerW => 'Avg Power (W)';

  @override
  String get totalEnergyKwh => 'Energy (kWh)';

  @override
  String get estimatedCost => 'Estimated Cost';

  @override
  String get dailyPredictionTitle => 'Daily Prediction (Last 7 Days)';

  @override
  String get dateColumn => 'Date';

  @override
  String get energyColumn => 'Energy (kWh)';

  @override
  String get costColumn => 'Cost';

  @override
  String get currencySymbol => 'Rp';

  @override
  String get defaultValue => '-';

  @override
  String get currencyFormat => 'Rpamount';

  @override
  String get defaultDisplayText => '-';

  @override
  String get decimalFormat => 'value';

  @override
  String get voltage => 'Voltage';

  @override
  String get current => 'Current';

  @override
  String get power => 'Power';

  @override
  String get energy => 'Energy';

  @override
  String get frequency => 'Frequency';

  @override
  String get powerFactor => 'Power Factor';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get voltageUnit => 'V';

  @override
  String get currentUnit => 'A';

  @override
  String get powerUnit => 'W';

  @override
  String get energyUnit => 'kWh';

  @override
  String get frequencyUnit => 'Hz';

  @override
  String get powerFactorUnit => 'VA';

  @override
  String get temperatureUnit => '°C';

  @override
  String get humidityUnit => '%';

  @override
  String get energyUsage => 'Energy Usage';

  @override
  String get energyAxisLabel => 'Energy (kWh)';

  @override
  String get energySeriesName => 'Energy';

  @override
  String get avgDaily => 'Avg Daily';

  @override
  String get peakToday => 'Peak Today';

  @override
  String get energyToday => 'Energy Today';

  @override
  String get kilowatt => 'kW';

  @override
  String get kilowattHour => 'kWh';

  @override
  String get energyHistory => 'Energy History';

  @override
  String get energyConsumption => 'Energy Consumption';

  @override
  String get energyConsumptionDescription =>
      'View historical energy consumption data';

  @override
  String get energyConsumptionData => 'Energy Consumption Data';

  @override
  String get hours => 'Hours';

  @override
  String get selectDateRange => 'Select Date Range';

  @override
  String get avgEnergy => 'Avg Energy';

  @override
  String get peakPower => 'Peak Power';

  @override
  String get totalEnergy => 'Total Energy';

  @override
  String get watt => 'Watt';

  @override
  String get loadingEnergyData => 'Loading energy data...';

  @override
  String get noEnergyData => 'No Energy Data Available';

  @override
  String get adjustDateRange =>
      'Try adjusting your date range or check your connection';

  @override
  String get hourlyPowerConsumption => 'Hourly Power Consumption';

  @override
  String get time => 'Time';

  @override
  String get dataLoadFailed => 'Failed to load data';

  @override
  String get sendFailed => 'Failed to send reset link';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get type => 'Type';

  @override
  String get building => 'Building';

  @override
  String deleteDeviceMessage(Object deviceName) {
    return 'Apakah Anda yakin ingin menghapus $deviceName?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String deviceDeleted(Object deviceName) {
    return '$deviceName berhasil dihapus';
  }

  @override
  String deleteFailed(Object error) {
    return 'Gagal menghapus perangkat: $error';
  }

  @override
  String get refresh => 'Refresh';

  @override
  String get saveChangesButton => 'Save Changes';
}
