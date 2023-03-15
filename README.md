# HDIP-POWERBI-Project

Name: Anders Ingelsten - 20095402

## General Overview.

This is a mobile app called Swimtrack - developed for the second assignment in the SETU Course: Mobile Application Development (HDip)

Lecturers: Dave Drohan & Dave Hearne

## App Overview + Functionality.

The Mobile Application is called Swimtrack and is a basic application where the user can track their swims
by adding the following details:

* Name of Swim spot - as text field

* Date of swim - as a pop up date picker


## Git Approach

I approached Git the following way:

When I thought i had an acceptable starting point I created and committed to the initial
repository. From there I committed everytime I made any small change or if i tried something 
and had to revert back to position where the app worked again. Then every time I had major 
functionality I published a release.

From version 2.5.0 I started using a couple of Dev Branches and merging/rebasing the project.

Sample view of commits and merged dev branches

![][view17]

* 2.0.1 Initial release, inc dark mode programmatically

* 2.1.0 Swipe delete support without db.

## Personal Statement

Coming from a swimming background, and specially a swimming background without wetsuits and less
gadgets, like wearables for tracking various data. These days a lot of fitness apps are linked to
wearable devices that is synced to apps and databases, so the purpose would suit users who are not


## Views/Pages.

The user is present of a splash screen when starting up the application and a list of any stored swims.

![][view1]

View of login with option of email or google auth

![][view2]


## Setup requirements.

To run the the code we recommend to make sure to use your own firebase account and
own google-service.json file.

Note the following minimum requirements:

MinSdk 30

TargetSdk 33

## Sources

Implementing test ad on the splash screen
https://developers.google.com/admob/android/quick-start#kotlin
https://apps.admob.com/
https://github.com/googleads/googleads-mobile-android-examples

Implementing test ad to the About
https://stackoverflow.com/questions/40740221/integrating-ad-in-fragment

### Swimtrack 2022 Version 2 - HDIP in Computer Science 2021 - Dep of Computing & Mathematics, SETU

[view1]: https://github.com/ingelsten/Swimtrack_v2/blob/master/Public/SW1.PNG
[view2]: https://github.com/ingelsten/Swimtrack_v2/blob/master/Public/SW2.PNG
[view3]: https://github.com/ingelsten/Swimtrack_v2/blob/master/Public/SW3.PNG
[view4]: https://github.com/ingelsten/Swimtrack_v2/blob/master/Public/SW4.PNG