import 'package:flutter/material.dart';

/// Placeholder for generated app localizations
/// This file will be replaced by flutter_localizations generator
abstract class AppLocalizations {
  /// Get the localizations instance from context
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// Locale delegate for the app
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('nl'),
    Locale('en'),
    Locale('de'),
    Locale('fr'),
    Locale('pl'),
    Locale('ro'),
  ];

  // Common strings
  String get appTitle;
  String get login;
  String get logout;
  String get email;
  String get password;
  String get forgotPassword;
  String get cancel;
  String get confirm;
  String get save;
  String get delete;
  String get edit;
  String get back;
  String get next;
  String get done;
  String get send;
  String get ok;
  String get error;
  String get success;
  String get loading;

  // Navigation
  String get home;
  String get trips;
  String get achievements;
  String get settings;
  String get profile;

  // Check flow
  String get startCheck;
  String get endCheck;
  String get checkCompleted;

  // Trip related
  String get tripActive;
  String get tripEnded;
  String get endTrip;
  String get activeTrip;

  // Incident related
  String get reportIncident;

  // Quick actions
  String get quickActions;
  String get recentActivity;

  // Panic button
  String get panicButton;
  String get panicConfirm;
  String get locationShared;

  // Streak
  String currentStreak(int days);

  // Welcome
  String welcomeBack(String name);
}

/// Default implementation with Dutch translations
class AppLocalizationsNl extends AppLocalizations {
  @override
  String get appTitle => 'DriverSense';

  @override
  String get login => 'Inloggen';

  @override
  String get logout => 'Uitloggen';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Wachtwoord';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get cancel => 'Annuleren';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get save => 'Opslaan';

  @override
  String get delete => 'Verwijderen';

  @override
  String get edit => 'Bewerken';

  @override
  String get back => 'Terug';

  @override
  String get next => 'Volgende';

  @override
  String get done => 'Klaar';

  @override
  String get send => 'Verzenden';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Fout';

  @override
  String get success => 'Gelukt';

  @override
  String get loading => 'Laden...';

  @override
  String get home => 'Home';

  @override
  String get trips => 'Ritten';

  @override
  String get achievements => 'Prestaties';

  @override
  String get settings => 'Instellingen';

  @override
  String get profile => 'Profiel';

  @override
  String get startCheck => 'Start check';

  @override
  String get endCheck => 'Eind check';

  @override
  String get checkCompleted => 'Check voltooid';

  @override
  String get tripActive => 'Rit actief';

  @override
  String get tripEnded => 'Rit beeindigd';

  @override
  String get endTrip => 'Rit beeindigen';

  @override
  String get activeTrip => 'Actieve rit';

  @override
  String get reportIncident => 'Incident melden';

  @override
  String get quickActions => 'Snelle acties';

  @override
  String get recentActivity => 'Recente activiteit';

  @override
  String get panicButton => 'Noodknop';

  @override
  String get panicConfirm => 'Weet je zeker dat je je locatie wilt delen met de planner?';

  @override
  String get locationShared => 'Locatie gedeeld met planner';

  @override
  String currentStreak(int days) => '$days dagen streak';

  @override
  String welcomeBack(String name) => 'Welkom terug, $name!';
}

/// English translations
class AppLocalizationsEn extends AppLocalizations {
  @override
  String get appTitle => 'DriverSense';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get send => 'Send';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get home => 'Home';

  @override
  String get trips => 'Trips';

  @override
  String get achievements => 'Achievements';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get startCheck => 'Start check';

  @override
  String get endCheck => 'End check';

  @override
  String get checkCompleted => 'Check completed';

  @override
  String get tripActive => 'Trip active';

  @override
  String get tripEnded => 'Trip ended';

  @override
  String get endTrip => 'End trip';

  @override
  String get activeTrip => 'Active trip';

  @override
  String get reportIncident => 'Report incident';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get panicButton => 'Panic button';

  @override
  String get panicConfirm => 'Are you sure you want to share your location with the planner?';

  @override
  String get locationShared => 'Location shared with planner';

  @override
  String currentStreak(int days) => '$days day streak';

  @override
  String welcomeBack(String name) => 'Welcome back, $name!';
}

/// Localization delegate
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['nl', 'en', 'de', 'fr', 'pl', 'ro'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'nl':
      default:
        return AppLocalizationsNl();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
