import QtQuick 2.0
import Ubuntu.Components 1.1

/*
    *******************************************
    *                                         *
    *       By Théo Friberg 29.10.2014        *
    *                                         *
    *******************************************

Webcomic-reader app for the Ubuntu Mobile platform.

         Copyright (c) 2014 Théo Friberg

Permission is hereby granted, free of charge, to
any person obtaining a copy of this software and
associated documentation files (the "Software"),
  to deal in the Software without restriction,
 including without limitation the rights to use,
   copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software,
  and to permit persons to whom the Software is
  furnished to do so, subject to the following
                  conditions:

The above copyright notice and this permission
   notice shall be included in all copies or
     substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
     WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
   OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
       OR OTHER DEALINGS IN THE SOFTWARE.

 COMICS DISPLAYED BY THIS SOFTWARE ARE PROPERTY OF
THEIR RESPECTIVE OWNERS. PERMISSION MUST BE GRANTED
BY THE COMICS' RESPECTIVE OWNERS TO REDISTRIBUTE ANY
  OR ALL THE COMICS. I, THÉO FRIBERG, DO NOT TAKE
RESPONSIBILITY FOR THE CONTENTS OF ANY OF THE COMICS
  DISPLAYED BY THIS SOFTWARE. COMICS REMAIN UNDER
      THEIR ORIGINAL LICENSES, WICH MAY VARY.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.username.tests"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(100)
    height: units.gu(75)

    Page {
        title: i18n.tr("Simple")

    }
}

