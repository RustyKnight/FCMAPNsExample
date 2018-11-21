# Firebase Cloud Messaging (FCM) Example
This is a simple example of using FCM on iOS to receive Remote Push Notifications
## Targets
The App is target to iOS 11+.  It should work on iOS 10 as well, but has not been tested on it.
## Carthage
The App makes use of the Carthage Dependency Management System to manage the library dependencies

There is a `update.sh` that can be used to update all the dependencies for iOS.
* Hermes
  Is a library based on the `UIUserNotification` API which also provides configuration enhancements and Promise extensions, curtesy of the Hydra library
* Hydra
  Is a “promises” library
* LogWrapperKit
  This provides a communalised API for logging, which can be “wrapped” around other logging frameworks
* FlowKit
  Is an extension to the table/collection view APIs which makes their configuration and management much simpler and faster to manage
## Certificates
Obviously, the App makes use of APNs certificates.  These are not included and will need to be configured against your own Apple Developer Account
## Google Firebase
Obviously, the App makes use of Googles Firebase API, you will need to configure your own and update the `GoogleService-Info.plist` accordingly.

The binaries for the API are managed through Carthage.  You will need to update it to download the binaries.
## PaintCode
The App makes use of PaintCode to generate all of its icons.

PaintCode provides a vector based solution for image assets which is graphics independent of the device (will renderer at the required scale) and helps reduce the App bundle size
## Realm
I had issues with getting Realm to work through Carthage (this is not surprising).  I usually keep a binary version stored in my own local binary repo, but this is not visible outside of my local network.   For this reason, I’ve included the Realm binaries within the source repo.  This is not a common practice I like to do, as I don’t like binaries in the repo (there are pros and cons, but this is not the place to discuss them)

