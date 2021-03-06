Project Prerequisites:
---------------------
- Java SDK 1.7 or later.
- Android SDK with API 22 and Android Build Tools 23.0.1 installed (they both can be installed from the SDK Manager).
- Android plugin for Gradle version 1.3.0.

Steps to build this project:
----------------------------

1. Using Android Studio, open "File" menu and select "New" -> "Import Project" option.

2. Using Gradle from the command line open a terminal window and navigate to the project root. On Windows platforms, type this command:

  > gradlew.bat assembleDebug

  On Mac OS and Linux platforms, type these commands:

  > chmod +x gradlew

  > ./gradlew assembleDebug

  The first command (chmod) adds the execution permission to the Gradle wrapper script and is only necessary the first time you build this project from the command line.

  The assembleDebug build task builds the debug version of your app and signs it with the default local certificate, so that you can install it on the emulator and on real devices for debugging purposes.

After you build the project, the output APK for the app module will be located in app/build/outputs/apk/ folder


Project Structure:
-----------------

- Module ``":app"``: the source code of our application, it contains all the files generated by IBM Mobile Appbuilder and it's the place where you can extend the app's functionality.

- Module ``":core"``: a framework library for our app, it contains all the common code and utility classes. If you need to modify the framework you can include it in the project, uncommenting the line ``include ':core'`` in the file settings.gradle.

- Depending on the features included in your app, the root folder could contain the source code for specific modules.

Modifying the Project:
---------------------
All the IBM Mobile Appbuilder specific dependencies will be included in the form of android archives (*.aar*) in the ``/app/libs/`` directory.
If you need to modify those libraries, remember to remove then from this folder, and including the relevant modules in the settings.gradle file. This way, you'll always have the latest changes compiled with your app.


External libraries:
------------------
Your application has been created using Open Source software. Please double-check the source code of the application to determine if it complies with your licensing needings.

For more information on open source licenses used by IBM Mobile Appbuilder, review the following:

	GreenRobot EventBus. Apache License 2.0
	(https://github.com/greenrobot/EventBus/blob/master/LICENSE)

	Square Picasso. Apache License 2.0
	(https://github.com/square/picasso/blob/master/LICENSE.txt)

	Square Retrofit. Apache License 2.0
	(https://github.com/square/retrofit/blob/master/LICENSE.txt)

	Android Better Pickers. Apache License 2.0
	(https://github.com/derekbrameyer/android-betterpickers)

	Path Android Priority Job Queue. Mit License
	(https://github.com/path/android-priority-jobqueue)

	Square OkHttp. Apache License 2.0
	(https://github.com/square/okhttp/blob/master/LICENSE.txt)

	Android Maps Utils. Apache License 2.0
	(https://github.com/googlemaps/android-maps-utils/blob/master/LICENSE)

	Androidplot. Apache License 2.0
	(https://github.com/halfhp/androidplot)

Testing dependencies:

	JUnit. Eclipse Public License 1.0
	(http://junit.org/license.html)

	jMock. jMock Project License
	(http://www.jmock.org/license.html)

	Hamcrest. BSD 3-Clause License
	(http://opensource.org/licenses/BSD-3-Clause)

