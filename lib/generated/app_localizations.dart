import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Etiop Application'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

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

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @informationWeCollect.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get informationWeCollect;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @usageData.
  ///
  /// In en, this message translates to:
  /// **'Usage Data'**
  String get usageData;

  /// No description provided for @howWeUseYourInformation.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get howWeUseYourInformation;

  /// No description provided for @serviceDelivery.
  ///
  /// In en, this message translates to:
  /// **'Service Delivery'**
  String get serviceDelivery;

  /// No description provided for @communication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communication;

  /// No description provided for @improvement.
  ///
  /// In en, this message translates to:
  /// **'Improvement'**
  String get improvement;

  /// No description provided for @dataSharing.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get dataSharing;

  /// No description provided for @securityOfYourInformation.
  ///
  /// In en, this message translates to:
  /// **'Security of Your Information'**
  String get securityOfYourInformation;

  /// No description provided for @yourRights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get yourRights;

  /// No description provided for @acceptanceOfTerms.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get acceptanceOfTerms;

  /// No description provided for @servicesProvided.
  ///
  /// In en, this message translates to:
  /// **'Services Provided'**
  String get servicesProvided;

  /// No description provided for @userResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'User Responsibilities'**
  String get userResponsibilities;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get accountSecurity;

  /// No description provided for @prohibitedActivities.
  ///
  /// In en, this message translates to:
  /// **'Prohibited Activities'**
  String get prohibitedActivities;

  /// No description provided for @limitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get limitationOfLiability;

  /// No description provided for @changesToTerms.
  ///
  /// In en, this message translates to:
  /// **'Changes to Terms'**
  String get changesToTerms;

  /// No description provided for @questionsAboutTerms.
  ///
  /// In en, this message translates to:
  /// **'Questions About Our Terms?'**
  String get questionsAboutTerms;

  /// No description provided for @questionsAboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Questions About Our Privacy Policy?'**
  String get questionsAboutPrivacy;

  /// No description provided for @contactSupportTeam.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about our Terms & Conditions, please contact our support team:'**
  String get contactSupportTeam;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In en, this message translates to:
  /// **'At ETIOP, we value your privacy and are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, disclose, and safeguard your information when you use our app.'**
  String get privacyPolicyIntro;

  /// No description provided for @personalInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'We may collect personal details such as your name, email address, phone number, and location when you register or use our services.'**
  String get personalInfoDescription;

  /// No description provided for @usageDataDescription.
  ///
  /// In en, this message translates to:
  /// **'We gather data on how you access and interact with our app, including device information, IP address, and browsing patterns.'**
  String get usageDataDescription;

  /// No description provided for @serviceDeliveryDescription.
  ///
  /// In en, this message translates to:
  /// **'To provide you with seamless access to government services, private sector resources, and public utilities.'**
  String get serviceDeliveryDescription;

  /// No description provided for @communicationDescription.
  ///
  /// In en, this message translates to:
  /// **'To send you updates, notifications, and promotional materials related to our services.'**
  String get communicationDescription;

  /// No description provided for @improvementDescription.
  ///
  /// In en, this message translates to:
  /// **'To analyze usage patterns and enhance user experience.'**
  String get improvementDescription;

  /// No description provided for @dataSharingDescription.
  ///
  /// In en, this message translates to:
  /// **'We do not sell or rent your personal information to third parties. We may share your information with trusted partners who assist us in providing our services while ensuring that they comply with privacy regulations.'**
  String get dataSharingDescription;

  /// No description provided for @securityDescription.
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate security measures to protect your data from unauthorized access or disclosure. However, no method of transmission over the internet or electronic storage is 100% secure.'**
  String get securityDescription;

  /// No description provided for @rightsDescription.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, correct, or delete your personal information at any time. For any inquiries regarding your data, please contact us through the app.'**
  String get rightsDescription;

  /// No description provided for @termsAcceptanceDescription.
  ///
  /// In en, this message translates to:
  /// **'By using ETIOP, you agree to comply with these Terms & Conditions. If you do not agree with any part of these terms, please refrain from using our services.'**
  String get termsAcceptanceDescription;

  /// No description provided for @servicesDescription.
  ///
  /// In en, this message translates to:
  /// **'ETIOP serves as a platform for accessing various government services, private sector resources, and public utilities. We strive to provide accurate and timely information but do not guarantee the completeness or reliability of the content.'**
  String get servicesDescription;

  /// No description provided for @accountSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.'**
  String get accountSecurityDescription;

  /// No description provided for @prohibitedActivitiesDescription.
  ///
  /// In en, this message translates to:
  /// **'You agree not to engage in any unlawful activities or misuse our platform in any way that could harm others or disrupt services.'**
  String get prohibitedActivitiesDescription;

  /// No description provided for @liabilityDescription.
  ///
  /// In en, this message translates to:
  /// **'ETIOP shall not be liable for any direct, indirect, incidental, or consequential damages arising from your use of our app or services. We do not guarantee uninterrupted access or error-free performance.'**
  String get liabilityDescription;

  /// No description provided for @changesDescription.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify these Terms & Conditions at any time. Any changes will be effective immediately upon posting in the app. Your continued use of ETIOP after such changes constitutes acceptance of the new terms.'**
  String get changesDescription;

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

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @subcategory.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get subcategory;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

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

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCode;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @minLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum length is {length} characters'**
  String minLength(Object length);

  /// No description provided for @maxLength.
  ///
  /// In en, this message translates to:
  /// **'Maximum length is {length} characters'**
  String maxLength(Object length);

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @sponsored.
  ///
  /// In en, this message translates to:
  /// **'Sponsored'**
  String get sponsored;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @highlightsOf.
  ///
  /// In en, this message translates to:
  /// **'Highlights of {district}'**
  String highlightsOf(Object district);

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// No description provided for @languageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChangedTo(Object language);

  /// No description provided for @myShops.
  ///
  /// In en, this message translates to:
  /// **'My Shops'**
  String get myShops;

  /// No description provided for @failedToLoadShops.
  ///
  /// In en, this message translates to:
  /// **'Failed to load shops'**
  String get failedToLoadShops;

  /// No description provided for @noShopsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No shops available'**
  String get noShopsAvailable;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopName;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @renewSubscription.
  ///
  /// In en, this message translates to:
  /// **'Renew Subscription'**
  String get renewSubscription;

  /// No description provided for @editShop.
  ///
  /// In en, this message translates to:
  /// **'Edit Shop'**
  String get editShop;

  /// No description provided for @deleteShop.
  ///
  /// In en, this message translates to:
  /// **'Delete Shop'**
  String get deleteShop;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteShop.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this shop?'**
  String get confirmDeleteShop;

  /// No description provided for @shopDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Shop deleted successfully'**
  String get shopDeletedSuccessfully;

  /// No description provided for @failedToDeleteShop.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete shop'**
  String get failedToDeleteShop;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotifications;

  /// No description provided for @noNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications yet'**
  String get noNotificationsMessage;

  /// No description provided for @noTimestamp.
  ///
  /// In en, this message translates to:
  /// **'No timestamp'**
  String get noTimestamp;

  /// No description provided for @invalidDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get invalidDate;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @invalidZipCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid ZIP code'**
  String get invalidZipCode;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access'**
  String get unauthorized;

  /// No description provided for @forbidden.
  ///
  /// In en, this message translates to:
  /// **'Access forbidden'**
  String get forbidden;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get notFound;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get timeout;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get tryAgain;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get goHome;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @swipeToDelete.
  ///
  /// In en, this message translates to:
  /// **'Swipe to delete'**
  String get swipeToDelete;

  /// No description provided for @swipeToEdit.
  ///
  /// In en, this message translates to:
  /// **'Swipe to edit'**
  String get swipeToEdit;

  /// No description provided for @swipeToView.
  ///
  /// In en, this message translates to:
  /// **'Swipe to view'**
  String get swipeToView;

  /// No description provided for @swipeToMore.
  ///
  /// In en, this message translates to:
  /// **'Swipe for more options'**
  String get swipeToMore;

  /// No description provided for @tapToExpand.
  ///
  /// In en, this message translates to:
  /// **'Tap to expand'**
  String get tapToExpand;

  /// No description provided for @tapToCollapse.
  ///
  /// In en, this message translates to:
  /// **'Tap to collapse'**
  String get tapToCollapse;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// No description provided for @tapToDeselect.
  ///
  /// In en, this message translates to:
  /// **'Tap to deselect'**
  String get tapToDeselect;

  /// No description provided for @longPressToDelete.
  ///
  /// In en, this message translates to:
  /// **'Long press to delete'**
  String get longPressToDelete;

  /// No description provided for @longPressToEdit.
  ///
  /// In en, this message translates to:
  /// **'Long press to edit'**
  String get longPressToEdit;

  /// No description provided for @longPressToView.
  ///
  /// In en, this message translates to:
  /// **'Long press to view'**
  String get longPressToView;

  /// No description provided for @longPressToMore.
  ///
  /// In en, this message translates to:
  /// **'Long press for more options'**
  String get longPressToMore;

  /// No description provided for @doubleTapToZoom.
  ///
  /// In en, this message translates to:
  /// **'Double tap to zoom'**
  String get doubleTapToZoom;

  /// No description provided for @doubleTapToLike.
  ///
  /// In en, this message translates to:
  /// **'Double tap to like'**
  String get doubleTapToLike;

  /// No description provided for @doubleTapToDislike.
  ///
  /// In en, this message translates to:
  /// **'Double tap to dislike'**
  String get doubleTapToDislike;

  /// No description provided for @pinchToZoom.
  ///
  /// In en, this message translates to:
  /// **'Pinch to zoom'**
  String get pinchToZoom;

  /// No description provided for @rotateToRotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate to rotate'**
  String get rotateToRotate;

  /// No description provided for @scrollToScroll.
  ///
  /// In en, this message translates to:
  /// **'Scroll to scroll'**
  String get scrollToScroll;

  /// No description provided for @dragToDrag.
  ///
  /// In en, this message translates to:
  /// **'Drag to drag'**
  String get dragToDrag;

  /// No description provided for @swipeToSwipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe to swipe'**
  String get swipeToSwipe;

  /// No description provided for @tapToTap.
  ///
  /// In en, this message translates to:
  /// **'Tap to tap'**
  String get tapToTap;

  /// No description provided for @holdToHold.
  ///
  /// In en, this message translates to:
  /// **'Hold to hold'**
  String get holdToHold;

  /// No description provided for @releaseToRelease.
  ///
  /// In en, this message translates to:
  /// **'Release to release'**
  String get releaseToRelease;

  /// No description provided for @moveToMove.
  ///
  /// In en, this message translates to:
  /// **'Move to move'**
  String get moveToMove;

  /// No description provided for @resizeToResize.
  ///
  /// In en, this message translates to:
  /// **'Resize to resize'**
  String get resizeToResize;

  /// No description provided for @selectToSelect.
  ///
  /// In en, this message translates to:
  /// **'Select to select'**
  String get selectToSelect;

  /// No description provided for @deselectToDeselect.
  ///
  /// In en, this message translates to:
  /// **'Deselect to deselect'**
  String get deselectToDeselect;

  /// No description provided for @enableToEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable to enable'**
  String get enableToEnable;

  /// No description provided for @disableToDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable to disable'**
  String get disableToDisable;

  /// No description provided for @showToShow.
  ///
  /// In en, this message translates to:
  /// **'Show to show'**
  String get showToShow;

  /// No description provided for @hideToHide.
  ///
  /// In en, this message translates to:
  /// **'Hide to hide'**
  String get hideToHide;

  /// No description provided for @openToOpen.
  ///
  /// In en, this message translates to:
  /// **'Open to open'**
  String get openToOpen;

  /// No description provided for @closeToClose.
  ///
  /// In en, this message translates to:
  /// **'Close to close'**
  String get closeToClose;

  /// No description provided for @startToStart.
  ///
  /// In en, this message translates to:
  /// **'Start to start'**
  String get startToStart;

  /// No description provided for @stopToStop.
  ///
  /// In en, this message translates to:
  /// **'Stop to stop'**
  String get stopToStop;

  /// No description provided for @pauseToPause.
  ///
  /// In en, this message translates to:
  /// **'Pause to pause'**
  String get pauseToPause;

  /// No description provided for @resumeToResume.
  ///
  /// In en, this message translates to:
  /// **'Resume to resume'**
  String get resumeToResume;

  /// No description provided for @playToPlay.
  ///
  /// In en, this message translates to:
  /// **'Play to play'**
  String get playToPlay;

  /// No description provided for @recordToRecord.
  ///
  /// In en, this message translates to:
  /// **'Record to record'**
  String get recordToRecord;

  /// No description provided for @captureToCapture.
  ///
  /// In en, this message translates to:
  /// **'Capture to capture'**
  String get captureToCapture;

  /// No description provided for @scanToScan.
  ///
  /// In en, this message translates to:
  /// **'Scan to scan'**
  String get scanToScan;

  /// No description provided for @uploadToUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload to upload'**
  String get uploadToUpload;

  /// No description provided for @downloadToDownload.
  ///
  /// In en, this message translates to:
  /// **'Download to download'**
  String get downloadToDownload;

  /// No description provided for @shareToShare.
  ///
  /// In en, this message translates to:
  /// **'Share to share'**
  String get shareToShare;

  /// No description provided for @exportToExport.
  ///
  /// In en, this message translates to:
  /// **'Export to export'**
  String get exportToExport;

  /// No description provided for @importToImport.
  ///
  /// In en, this message translates to:
  /// **'Import to import'**
  String get importToImport;

  /// No description provided for @syncToSync.
  ///
  /// In en, this message translates to:
  /// **'Sync to sync'**
  String get syncToSync;

  /// No description provided for @backupToBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup to backup'**
  String get backupToBackup;

  /// No description provided for @restoreToRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore to restore'**
  String get restoreToRestore;

  /// No description provided for @resetToReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to reset'**
  String get resetToReset;

  /// No description provided for @clearToClear.
  ///
  /// In en, this message translates to:
  /// **'Clear to clear'**
  String get clearToClear;

  /// No description provided for @copyToCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy to copy'**
  String get copyToCopy;

  /// No description provided for @pasteToPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste to paste'**
  String get pasteToPaste;

  /// No description provided for @cutToCut.
  ///
  /// In en, this message translates to:
  /// **'Cut to cut'**
  String get cutToCut;

  /// No description provided for @undoToUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo to undo'**
  String get undoToUndo;

  /// No description provided for @redoToRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo to redo'**
  String get redoToRedo;

  /// No description provided for @selectAllToSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all to select all'**
  String get selectAllToSelectAll;

  /// No description provided for @deselectAllToDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all to deselect all'**
  String get deselectAllToDeselectAll;

  /// No description provided for @invertSelectionToInvertSelection.
  ///
  /// In en, this message translates to:
  /// **'Invert selection to invert selection'**
  String get invertSelectionToInvertSelection;

  /// No description provided for @expandAllToExpandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand all to expand all'**
  String get expandAllToExpandAll;

  /// No description provided for @collapseAllToCollapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse all to collapse all'**
  String get collapseAllToCollapseAll;

  /// No description provided for @showAllToShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all to show all'**
  String get showAllToShowAll;

  /// No description provided for @hideAllToHideAll.
  ///
  /// In en, this message translates to:
  /// **'Hide all to hide all'**
  String get hideAllToHideAll;

  /// No description provided for @enableAllToEnableAll.
  ///
  /// In en, this message translates to:
  /// **'Enable all to enable all'**
  String get enableAllToEnableAll;

  /// No description provided for @disableAllToDisableAll.
  ///
  /// In en, this message translates to:
  /// **'Disable all to disable all'**
  String get disableAllToDisableAll;

  /// No description provided for @selectNoneToSelectNone.
  ///
  /// In en, this message translates to:
  /// **'Select none to select none'**
  String get selectNoneToSelectNone;

  /// No description provided for @selectDefaultToSelectDefault.
  ///
  /// In en, this message translates to:
  /// **'Select default to select default'**
  String get selectDefaultToSelectDefault;

  /// No description provided for @selectCustomToSelectCustom.
  ///
  /// In en, this message translates to:
  /// **'Select custom to select custom'**
  String get selectCustomToSelectCustom;

  /// No description provided for @selectMultipleToSelectMultiple.
  ///
  /// In en, this message translates to:
  /// **'Select multiple to select multiple'**
  String get selectMultipleToSelectMultiple;

  /// No description provided for @selectSingleToSelectSingle.
  ///
  /// In en, this message translates to:
  /// **'Select single to select single'**
  String get selectSingleToSelectSingle;

  /// No description provided for @selectRangeToSelectRange.
  ///
  /// In en, this message translates to:
  /// **'Select range to select range'**
  String get selectRangeToSelectRange;

  /// No description provided for @selectPatternToSelectPattern.
  ///
  /// In en, this message translates to:
  /// **'Select pattern to select pattern'**
  String get selectPatternToSelectPattern;

  /// No description provided for @selectInverseToSelectInverse.
  ///
  /// In en, this message translates to:
  /// **'Select inverse to select inverse'**
  String get selectInverseToSelectInverse;

  /// No description provided for @selectSimilarToSelectSimilar.
  ///
  /// In en, this message translates to:
  /// **'Select similar to select similar'**
  String get selectSimilarToSelectSimilar;

  /// No description provided for @selectOtherToSelectOther.
  ///
  /// In en, this message translates to:
  /// **'Select other to select other'**
  String get selectOtherToSelectOther;

  /// No description provided for @selectAllSimilarToSelectAllSimilar.
  ///
  /// In en, this message translates to:
  /// **'Select all similar to select all similar'**
  String get selectAllSimilarToSelectAllSimilar;

  /// No description provided for @selectAllOtherToSelectAllOther.
  ///
  /// In en, this message translates to:
  /// **'Select all other to select all other'**
  String get selectAllOtherToSelectAllOther;

  /// No description provided for @selectAllInverseToSelectAllInverse.
  ///
  /// In en, this message translates to:
  /// **'Select all inverse to select all inverse'**
  String get selectAllInverseToSelectAllInverse;

  /// No description provided for @selectAllPatternToSelectAllPattern.
  ///
  /// In en, this message translates to:
  /// **'Select all pattern to select all pattern'**
  String get selectAllPatternToSelectAllPattern;

  /// No description provided for @selectAllRangeToSelectAllRange.
  ///
  /// In en, this message translates to:
  /// **'Select all range to select all range'**
  String get selectAllRangeToSelectAllRange;

  /// No description provided for @selectAllMultipleToSelectAllMultiple.
  ///
  /// In en, this message translates to:
  /// **'Select all multiple to select all multiple'**
  String get selectAllMultipleToSelectAllMultiple;

  /// No description provided for @selectAllSingleToSelectAllSingle.
  ///
  /// In en, this message translates to:
  /// **'Select all single to select all single'**
  String get selectAllSingleToSelectAllSingle;

  /// No description provided for @selectAllCustomToSelectAllCustom.
  ///
  /// In en, this message translates to:
  /// **'Select all custom to select all custom'**
  String get selectAllCustomToSelectAllCustom;

  /// No description provided for @selectAllDefaultToSelectAllDefault.
  ///
  /// In en, this message translates to:
  /// **'Select all default to select all default'**
  String get selectAllDefaultToSelectAllDefault;

  /// No description provided for @selectAllNoneToSelectAllNone.
  ///
  /// In en, this message translates to:
  /// **'Select all none to select all none'**
  String get selectAllNoneToSelectAllNone;

  /// No description provided for @myBusinesses.
  ///
  /// In en, this message translates to:
  /// **'My Businesses'**
  String get myBusinesses;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @noAddressProvided.
  ///
  /// In en, this message translates to:
  /// **'No address provided'**
  String get noAddressProvided;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @noShopsFound.
  ///
  /// In en, this message translates to:
  /// **'No Shops Found'**
  String get noShopsFound;

  /// No description provided for @noShopsMessage.
  ///
  /// In en, this message translates to:
  /// **'You have not created any shops yet. Would you like to create one?'**
  String get noShopsMessage;

  /// No description provided for @createShop.
  ///
  /// In en, this message translates to:
  /// **'Create Shop'**
  String get createShop;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help? We\'re here to assist you!'**
  String get needHelp;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberHint;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailAddressHint;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get message;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your enquiry or issue'**
  String get messageHint;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your message'**
  String get pleaseEnterMessage;

  /// No description provided for @submitEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Submit Enquiry'**
  String get submitEnquiry;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us: {phone}'**
  String callUs(String phone);

  /// No description provided for @enquirySubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your enquiry has been submitted successfully!'**
  String get enquirySubmitted;

  /// No description provided for @failedToSubmitEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit the enquiry.'**
  String get failedToSubmitEnquiry;

  /// No description provided for @userInfoNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'User information is not available.'**
  String get userInfoNotAvailable;

  /// No description provided for @enquiryError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String enquiryError(String error);

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccessful;

  /// No description provided for @invalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid response from server'**
  String get invalidResponse;

  /// No description provided for @errorRegisteringUser.
  ///
  /// In en, this message translates to:
  /// **'Error registering user: {error}'**
  String errorRegisteringUser(String error);

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get lastNameHint;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmailFormat;

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get mobileNumberHint;

  /// No description provided for @stateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a state'**
  String get stateRequired;

  /// No description provided for @districtRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a district'**
  String get districtRequired;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get addressHint;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @validMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit mobile number'**
  String get validMobileRequired;

  /// No description provided for @shopAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Shop added successfully!'**
  String get shopAddedSuccessfully;

  /// No description provided for @failedToAddShop.
  ///
  /// In en, this message translates to:
  /// **'Failed to add shop'**
  String get failedToAddShop;

  /// No description provided for @addShop.
  ///
  /// In en, this message translates to:
  /// **'Add Shop'**
  String get addShop;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get categoryRequired;

  /// No description provided for @subcategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a subcategory'**
  String get subcategoryRequired;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @userIDNotFound.
  ///
  /// In en, this message translates to:
  /// **'User ID not found'**
  String get userIDNotFound;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @errorUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile: {error}'**
  String errorUpdatingProfile(String error);

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @shopDetails.
  ///
  /// In en, this message translates to:
  /// **'Shop Details'**
  String get shopDetails;

  /// No description provided for @failedToLoadShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load shop details.'**
  String get failedToLoadShopDetails;

  /// No description provided for @catalogImages.
  ///
  /// In en, this message translates to:
  /// **'Catalog Images:'**
  String get catalogImages;

  /// No description provided for @noOfficeNameAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Office Name Available'**
  String get noOfficeNameAvailable;

  /// No description provided for @noNameAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Name Available'**
  String get noNameAvailable;

  /// No description provided for @noPhoneNumberAvailable.
  ///
  /// In en, this message translates to:
  /// **'No phone number available'**
  String get noPhoneNumberAvailable;

  /// No description provided for @noEmailAvailable.
  ///
  /// In en, this message translates to:
  /// **'No email available'**
  String get noEmailAvailable;

  /// No description provided for @noWebsiteAvailable.
  ///
  /// In en, this message translates to:
  /// **'No website available'**
  String get noWebsiteAvailable;

  /// No description provided for @noDirectionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No direction available'**
  String get noDirectionAvailable;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category:'**
  String get categoryLabel;

  /// No description provided for @subCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Sub Category:'**
  String get subCategoryLabel;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department:'**
  String get department;

  /// No description provided for @officer.
  ///
  /// In en, this message translates to:
  /// **'Officer:'**
  String get officer;

  /// No description provided for @noDepartmentNameAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Department Name Available'**
  String get noDepartmentNameAvailable;

  /// No description provided for @noOfficerNameAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Officer Name Available'**
  String get noOfficerNameAvailable;

  /// No description provided for @catalogueImages.
  ///
  /// In en, this message translates to:
  /// **'Catalogue Images'**
  String get catalogueImages;

  /// No description provided for @relatedServices.
  ///
  /// In en, this message translates to:
  /// **'Related Services:'**
  String get relatedServices;

  /// No description provided for @sendRequirement.
  ///
  /// In en, this message translates to:
  /// **'Send Requirement'**
  String get sendRequirement;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @shopNo.
  ///
  /// In en, this message translates to:
  /// **'Shop No'**
  String get shopNo;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @zipcode.
  ///
  /// In en, this message translates to:
  /// **'Zipcode'**
  String get zipcode;

  /// No description provided for @websiteLink.
  ///
  /// In en, this message translates to:
  /// **'Website Link'**
  String get websiteLink;

  /// No description provided for @googleMapLink.
  ///
  /// In en, this message translates to:
  /// **'Google Map Link'**
  String get googleMapLink;

  /// No description provided for @mainPhoto.
  ///
  /// In en, this message translates to:
  /// **'Main Photo'**
  String get mainPhoto;

  /// No description provided for @pickAnImage.
  ///
  /// In en, this message translates to:
  /// **'Pick an Image'**
  String get pickAnImage;

  /// No description provided for @spotName.
  ///
  /// In en, this message translates to:
  /// **'Spot Name'**
  String get spotName;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @emailId.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get emailId;

  /// No description provided for @spotAddress.
  ///
  /// In en, this message translates to:
  /// **'Spot Address'**
  String get spotAddress;

  /// No description provided for @officeAddress.
  ///
  /// In en, this message translates to:
  /// **'Office Address'**
  String get officeAddress;

  /// No description provided for @googleMapLocation.
  ///
  /// In en, this message translates to:
  /// **'Google Map Location'**
  String get googleMapLocation;

  /// No description provided for @departmentName.
  ///
  /// In en, this message translates to:
  /// **'Department Name'**
  String get departmentName;

  /// No description provided for @officeName.
  ///
  /// In en, this message translates to:
  /// **'Office Name'**
  String get officeName;

  /// No description provided for @officerName.
  ///
  /// In en, this message translates to:
  /// **'Officer Name'**
  String get officerName;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category to view the form'**
  String get pleaseSelectCategory;

  /// No description provided for @thisFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldRequired;

  /// No description provided for @pleaseSelectState.
  ///
  /// In en, this message translates to:
  /// **'Please select a state'**
  String get pleaseSelectState;

  /// No description provided for @pleaseSelectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Please select a district'**
  String get pleaseSelectDistrict;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @editShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Shop Details'**
  String get editShopDetails;

  /// No description provided for @shopImage.
  ///
  /// In en, this message translates to:
  /// **'Shop Image'**
  String get shopImage;

  /// No description provided for @chooseImageSource.
  ///
  /// In en, this message translates to:
  /// **'Choose Image Source'**
  String get chooseImageSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @maximumCatalogImages.
  ///
  /// In en, this message translates to:
  /// **'Maximum 5 catalog images allowed'**
  String get maximumCatalogImages;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @errorFetchingCategories.
  ///
  /// In en, this message translates to:
  /// **'Error fetching categories: {error}'**
  String errorFetchingCategories(Object error);

  /// No description provided for @noSubcategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No subcategories available'**
  String get noSubcategoriesAvailable;

  /// No description provided for @failedToLoadSubcategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load subcategories'**
  String get failedToLoadSubcategories;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
