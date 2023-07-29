# Setup

How to install and setup the App:

* Make sure you have installed Cocapods
* Unzip the project
* Do `pod install` in the Terminal
* Open `Tendable.xcworkspace`
* Download the code https://github.com/tendable/candidate-mobile-interview-webserver
* In a Terminal run `python3 run.py`
* The App can then be run from Xcode.

# App Features

Here are the implemented features:

1. Login with a user name and password. If there isn't a user available you will need to register.
2. Start an inspection after logging in. In offline mode, press the "Continue" button on the Login Screen.
3. Inspections are saved to Core Data for Persistence. You can close the App and the same Inspection with entered answers can be continued.
4. Submissions can be submitted when ready.

# Assumptions / Notes

* Only one Inspection at a time is to be done. This is based on the text which summarises the features. Support for multiple inspections can be added since all the Questions / Categories / Answers are linked.
* Offline mode is not a requirement, but I have support for this.
* User information is not required to be sent for submitted inspections.
* Typically I would have added more testing, but this was constrained due to time.
