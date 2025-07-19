import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @systemInformation.
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemInformation;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @verifiedEmail.
  ///
  /// In en, this message translates to:
  /// **'Verified Email'**
  String get verifiedEmail;

  /// No description provided for @already.
  ///
  /// In en, this message translates to:
  /// **'Already'**
  String get already;

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get notYet;

  /// No description provided for @lastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last Login'**
  String get lastLogin;

  /// No description provided for @madeIn.
  ///
  /// In en, this message translates to:
  /// **'Made In'**
  String get madeIn;

  /// No description provided for @updatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated On'**
  String get updatedOn;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout Confirmation'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of this account?'**
  String get logoutConfirmationMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get confirmLogout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @pleaseEnterField.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String pleaseEnterField(Object field);

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDevice;

  /// No description provided for @deviceList.
  ///
  /// In en, this message translates to:
  /// **'Device List'**
  String get deviceList;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @completeAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Complete\naccount information'**
  String get completeAccountInfo;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'No. Hp'**
  String get phoneLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String fieldRequired(Object field);

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'New password and confirmation do not match'**
  String get passwordMismatch;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordHeader.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordHeader;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'We will send a link to reset your password to your email.'**
  String get forgotPasswordDescription;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInTitle;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInButton;

  /// No description provided for @noAccountText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet?'**
  String get noAccountText;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpLink;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpTitle;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLink;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields required'**
  String get allFieldsRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @smartHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Home'**
  String get smartHomeTitle;

  /// No description provided for @smartHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control your smart devices'**
  String get smartHomeSubtitle;

  /// No description provided for @deviceControl.
  ///
  /// In en, this message translates to:
  /// **'Device Control'**
  String get deviceControl;

  /// No description provided for @noControlDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a control device'**
  String get noControlDeviceTitle;

  /// No description provided for @noControlDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please add a control device first.'**
  String get noControlDeviceSubtitle;

  /// No description provided for @quickScenes.
  ///
  /// In en, this message translates to:
  /// **'Quick Scenes'**
  String get quickScenes;

  /// No description provided for @allOn.
  ///
  /// In en, this message translates to:
  /// **'All On'**
  String get allOn;

  /// No description provided for @allOff.
  ///
  /// In en, this message translates to:
  /// **'All Off'**
  String get allOff;

  /// No description provided for @statusOn.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get statusOn;

  /// No description provided for @statusOff.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get statusOff;

  /// Number of active devices
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String activeDevices(Object count);

  /// No description provided for @addDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Device'**
  String get addDeviceTitle;

  /// No description provided for @deviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceNameLabel;

  /// No description provided for @deviceIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceIdLabel;

  /// No description provided for @deviceTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get deviceTypeLabel;

  /// No description provided for @deviceBuildingLabel.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get deviceBuildingLabel;

  /// No description provided for @installationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Installation Date'**
  String get installationDateLabel;

  /// No description provided for @selectDateText.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDateText;

  /// No description provided for @saveDeviceButton.
  ///
  /// In en, this message translates to:
  /// **'SAVE DEVICE'**
  String get saveDeviceButton;

  /// No description provided for @pleaseSelectDeviceType.
  ///
  /// In en, this message translates to:
  /// **'Please select device type'**
  String get pleaseSelectDeviceType;

  /// No description provided for @pleaseSelectInstallationDate.
  ///
  /// In en, this message translates to:
  /// **'Please select installation date'**
  String get pleaseSelectInstallationDate;

  /// No description provided for @deviceAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device added successfully'**
  String get deviceAddedSuccess;

  /// Error message when device add fails
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String deviceAddError(Object error);

  /// No description provided for @deviceListTitle.
  ///
  /// In en, this message translates to:
  /// **'Device List'**
  String get deviceListTitle;

  /// No description provided for @noDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices available'**
  String get noDevices;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deviceId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceId;

  /// No description provided for @deviceType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get deviceType;

  /// No description provided for @deviceBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get deviceBuilding;

  /// No description provided for @installationDate.
  ///
  /// In en, this message translates to:
  /// **'Installation Date'**
  String get installationDate;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactive;

  /// No description provided for @statusMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get statusMaintenance;

  /// No description provided for @deleteDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Device'**
  String get deleteDeviceTitle;

  /// No description provided for @deleteDeviceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete device {deviceName}?'**
  String deleteDeviceConfirm(Object deviceName);

  /// No description provided for @deleteDeviceSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device {deviceName} deleted successfully'**
  String deleteDeviceSuccess(Object deviceName);

  /// No description provided for @deleteDeviceError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete device: {error}'**
  String deleteDeviceError(Object error);

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get confirmDelete;

  /// No description provided for @editDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Device'**
  String get editDeviceTitle;

  /// No description provided for @deviceStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get deviceStatusLabel;

  /// No description provided for @deviceSaveButton.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get deviceSaveButton;

  /// No description provided for @deviceUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device updated successfully'**
  String get deviceUpdatedSuccess;

  /// No description provided for @deviceUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update: {error}'**
  String deviceUpdateError(Object error);

  /// No description provided for @userGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Power Management Application Usage Guide'**
  String get userGuideTitle;

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get introTitle;

  /// No description provided for @introContent.
  ///
  /// In en, this message translates to:
  /// **'Smart Power Management is an application to monitor and control electrical systems efficiently. Make sure you have a stable internet connection for optimal performance.'**
  String get introContent;

  /// No description provided for @installTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Installation and Preparation'**
  String get installTitle;

  /// No description provided for @downloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Download and Install the App'**
  String get downloadTitle;

  /// No description provided for @downloadContent.
  ///
  /// In en, this message translates to:
  /// **'Download Smart Power Management on Google Play Store or Apple Store. Make sure the device has enough storage space.'**
  String get downloadContent;

  /// No description provided for @internetTitle.
  ///
  /// In en, this message translates to:
  /// **'Internet Connection'**
  String get internetTitle;

  /// No description provided for @internetContent.
  ///
  /// In en, this message translates to:
  /// **'Make sure the device is connected to a stable internet connection to ensure the application works properly.'**
  String get internetContent;

  /// No description provided for @monitoringTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Add Monitoring Device'**
  String get monitoringTitle;

  /// No description provided for @openMonitoringTitle.
  ///
  /// In en, this message translates to:
  /// **'Open the Monitoring Menu'**
  String get openMonitoringTitle;

  /// No description provided for @openMonitoringContent.
  ///
  /// In en, this message translates to:
  /// **'On the main page of the application, select the Monitoring menu.'**
  String get openMonitoringContent;

  /// No description provided for @addMonitoringDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Device'**
  String get addMonitoringDeviceTitle;

  /// No description provided for @addMonitoringDeviceContent.
  ///
  /// In en, this message translates to:
  /// **'Press the (+) icon, then enter the device ID and password provided by the technician.'**
  String get addMonitoringDeviceContent;

  /// No description provided for @controllingTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Connecting Control Devices'**
  String get controllingTitle;

  /// No description provided for @openControllingTitle.
  ///
  /// In en, this message translates to:
  /// **'Open the Controlling Menu'**
  String get openControllingTitle;

  /// No description provided for @openControllingContent.
  ///
  /// In en, this message translates to:
  /// **'From the main page, select the Controlling menu to start connecting control devices.'**
  String get openControllingContent;

  /// No description provided for @addControllingDeviceContent.
  ///
  /// In en, this message translates to:
  /// **'Enter device information such as name, IP address, and access code correctly.'**
  String get addControllingDeviceContent;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Tips and Troubleshooting'**
  String get tipsTitle;

  /// No description provided for @cannotConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Cannot Connect'**
  String get cannotConnectTitle;

  /// No description provided for @cannotConnectContent.
  ///
  /// In en, this message translates to:
  /// **'Make sure the ID and Password entered are correct, and the device is in pairing mode.'**
  String get cannotConnectContent;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical Support'**
  String get supportTitle;

  /// No description provided for @supportContent.
  ///
  /// In en, this message translates to:
  /// **'If you experience any issues, please contact customer service via the in-app technical support feature.'**
  String get supportContent;

  /// No description provided for @closingMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to use Smart Power Management for smarter and more efficient electricity management!'**
  String get closingMessage;

  /// No description provided for @homeWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome\n{name}!'**
  String homeWelcomeTitle(Object name);

  /// No description provided for @homeIntroText.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start stabilizing our power output!'**
  String get homeIntroText;

  /// No description provided for @homeMenuMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get homeMenuMonitoring;

  /// No description provided for @homeMenuControlling.
  ///
  /// In en, this message translates to:
  /// **'Controlling'**
  String get homeMenuControlling;

  /// No description provided for @homeMenuAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get homeMenuAccount;

  /// No description provided for @homeMenuUserGuide.
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get homeMenuUserGuide;

  /// No description provided for @monitorHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor your electricity\nconsumption!'**
  String get monitorHeaderTitle;

  /// No description provided for @monitorHistoryButton.
  ///
  /// In en, this message translates to:
  /// **'View Data History'**
  String get monitorHistoryButton;

  /// No description provided for @monitorDeviceUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitoring device is not available'**
  String get monitorDeviceUnavailableTitle;

  /// No description provided for @monitorDeviceUnavailableDesc.
  ///
  /// In en, this message translates to:
  /// **'Please register your monitoring device first to access this feature.'**
  String get monitorDeviceUnavailableDesc;

  /// No description provided for @monitorLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Monitoring Data'**
  String get monitorLiveTitle;

  /// No description provided for @monitorPredictionDropdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Prediction Option:'**
  String get monitorPredictionDropdownLabel;

  /// No description provided for @monitorChartVoltageCurrent.
  ///
  /// In en, this message translates to:
  /// **'Voltage & Current'**
  String get monitorChartVoltageCurrent;

  /// No description provided for @monitorChartPowerEnergy.
  ///
  /// In en, this message translates to:
  /// **'Power & Energy'**
  String get monitorChartPowerEnergy;

  /// No description provided for @monitorChartFreqPf.
  ///
  /// In en, this message translates to:
  /// **'Frequency & Power Factor'**
  String get monitorChartFreqPf;

  /// No description provided for @monitorChartTempHumidity.
  ///
  /// In en, this message translates to:
  /// **'Temperature & Humidity'**
  String get monitorChartTempHumidity;

  /// No description provided for @monitorDatetimeWIB.
  ///
  /// In en, this message translates to:
  /// **'{date} : {time} WIB'**
  String monitorDatetimeWIB(Object date, Object time);

  /// No description provided for @monitorMetricVoltage.
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get monitorMetricVoltage;

  /// No description provided for @monitorMetricCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get monitorMetricCurrent;

  /// No description provided for @monitorMetricPower.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get monitorMetricPower;

  /// No description provided for @monitorMetricEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get monitorMetricEnergy;

  /// No description provided for @monitorMetricFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get monitorMetricFrequency;

  /// No description provided for @monitorMetricPowerFactor.
  ///
  /// In en, this message translates to:
  /// **'Power Factor'**
  String get monitorMetricPowerFactor;

  /// No description provided for @monitorMetricTemp.
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get monitorMetricTemp;

  /// No description provided for @monitorMetricHumidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get monitorMetricHumidity;

  /// No description provided for @welcomeGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get welcomeGetStarted;

  /// No description provided for @welcomeSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get welcomeSignUp;

  /// No description provided for @welcomeSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get welcomeSignIn;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get emailRequired;

  /// No description provided for @linkSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset link has been sent to your email.'**
  String get linkSentSuccess;

  /// No description provided for @linkSentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset link. Please try again later.'**
  String get linkSentFailed;

  /// No description provided for @emailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email Verified'**
  String get emailVerified;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @emailAlreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'Your email is already verified'**
  String get emailAlreadyVerified;

  /// No description provided for @enterVerificationCodeSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code sent to your email.'**
  String get enterVerificationCodeSentToEmail;

  /// No description provided for @pleaseEnter6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 6-digit code'**
  String get pleaseEnter6DigitCode;

  /// No description provided for @emailSuccessfullyVerified.
  ///
  /// In en, this message translates to:
  /// **'Email successfully verified!'**
  String get emailSuccessfullyVerified;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;

  /// No description provided for @verificationCodeResent.
  ///
  /// In en, this message translates to:
  /// **'Verification code resent'**
  String get verificationCodeResent;

  /// No description provided for @failedToResendCode.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend code'**
  String get failedToResendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @inactiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactiveStatus;

  /// No description provided for @predictionDataNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Prediction data not available'**
  String get predictionDataNotAvailable;

  /// No description provided for @energyPrediction.
  ///
  /// In en, this message translates to:
  /// **'Energy Prediction'**
  String get energyPrediction;

  /// No description provided for @dailyPrediction.
  ///
  /// In en, this message translates to:
  /// **'Daily Prediction'**
  String get dailyPrediction;

  /// No description provided for @monthlyPrediction.
  ///
  /// In en, this message translates to:
  /// **'Monthly Prediction'**
  String get monthlyPrediction;

  /// No description provided for @yearlyPrediction.
  ///
  /// In en, this message translates to:
  /// **'Yearly Prediction'**
  String get yearlyPrediction;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @averagePowerW.
  ///
  /// In en, this message translates to:
  /// **'Avg Power (W)'**
  String get averagePowerW;

  /// No description provided for @totalEnergyKwh.
  ///
  /// In en, this message translates to:
  /// **'Energy (kWh)'**
  String get totalEnergyKwh;

  /// No description provided for @estimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost'**
  String get estimatedCost;

  /// No description provided for @dailyPredictionTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Prediction (Last 7 Days)'**
  String get dailyPredictionTitle;

  /// No description provided for @dateColumn.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateColumn;

  /// No description provided for @energyColumn.
  ///
  /// In en, this message translates to:
  /// **'Energy (kWh)'**
  String get energyColumn;

  /// No description provided for @costColumn.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get costColumn;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Rp'**
  String get currencySymbol;

  /// No description provided for @defaultValue.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get defaultValue;

  /// No description provided for @currencyFormat.
  ///
  /// In en, this message translates to:
  /// **'\\\$amount'**
  String get currencyFormat;

  /// No description provided for @defaultDisplayText.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get defaultDisplayText;

  /// No description provided for @decimalFormat.
  ///
  /// In en, this message translates to:
  /// **'value'**
  String get decimalFormat;

  /// No description provided for @voltage.
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get voltage;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @powerFactor.
  ///
  /// In en, this message translates to:
  /// **'Power Factor'**
  String get powerFactor;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @voltageUnit.
  ///
  /// In en, this message translates to:
  /// **'V'**
  String get voltageUnit;

  /// No description provided for @currentUnit.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get currentUnit;

  /// No description provided for @powerUnit.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get powerUnit;

  /// No description provided for @energyUnit.
  ///
  /// In en, this message translates to:
  /// **'kWh'**
  String get energyUnit;

  /// No description provided for @frequencyUnit.
  ///
  /// In en, this message translates to:
  /// **'Hz'**
  String get frequencyUnit;

  /// No description provided for @powerFactorUnit.
  ///
  /// In en, this message translates to:
  /// **'VA'**
  String get powerFactorUnit;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get temperatureUnit;

  /// No description provided for @humidityUnit.
  ///
  /// In en, this message translates to:
  /// **'%'**
  String get humidityUnit;

  /// No description provided for @energyUsage.
  ///
  /// In en, this message translates to:
  /// **'Energy Usage'**
  String get energyUsage;

  /// No description provided for @energyAxisLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy (kWh)'**
  String get energyAxisLabel;

  /// No description provided for @energySeriesName.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energySeriesName;

  /// No description provided for @avgDaily.
  ///
  /// In en, this message translates to:
  /// **'Avg Daily'**
  String get avgDaily;

  /// No description provided for @peakToday.
  ///
  /// In en, this message translates to:
  /// **'Peak Today'**
  String get peakToday;

  /// No description provided for @energyToday.
  ///
  /// In en, this message translates to:
  /// **'Energy Today'**
  String get energyToday;

  /// No description provided for @kilowatt.
  ///
  /// In en, this message translates to:
  /// **'kW'**
  String get kilowatt;

  /// No description provided for @kilowattHour.
  ///
  /// In en, this message translates to:
  /// **'kWh'**
  String get kilowattHour;

  /// No description provided for @energyHistory.
  ///
  /// In en, this message translates to:
  /// **'Energy History'**
  String get energyHistory;

  /// No description provided for @energyConsumption.
  ///
  /// In en, this message translates to:
  /// **'Energy Consumption'**
  String get energyConsumption;

  /// No description provided for @energyConsumptionDescription.
  ///
  /// In en, this message translates to:
  /// **'View historical energy consumption data'**
  String get energyConsumptionDescription;

  /// No description provided for @energyConsumptionData.
  ///
  /// In en, this message translates to:
  /// **'Energy Consumption Data'**
  String get energyConsumptionData;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @avgEnergy.
  ///
  /// In en, this message translates to:
  /// **'Avg Energy'**
  String get avgEnergy;

  /// No description provided for @peakPower.
  ///
  /// In en, this message translates to:
  /// **'Peak Power'**
  String get peakPower;

  /// No description provided for @totalEnergy.
  ///
  /// In en, this message translates to:
  /// **'Total Energy'**
  String get totalEnergy;

  /// No description provided for @watt.
  ///
  /// In en, this message translates to:
  /// **'Watt'**
  String get watt;

  /// No description provided for @loadingEnergyData.
  ///
  /// In en, this message translates to:
  /// **'Loading energy data...'**
  String get loadingEnergyData;

  /// No description provided for @noEnergyData.
  ///
  /// In en, this message translates to:
  /// **'No Energy Data Available'**
  String get noEnergyData;

  /// No description provided for @adjustDateRange.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your date range or check your connection'**
  String get adjustDateRange;

  /// No description provided for @hourlyPowerConsumption.
  ///
  /// In en, this message translates to:
  /// **'Hourly Power Consumption'**
  String get hourlyPowerConsumption;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @dataLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get dataLoadFailed;

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset link'**
  String get sendFailed;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
