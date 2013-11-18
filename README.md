lunarhaxorz-png-mobile
======================

mobile app for recording medical data


getting started
---------------


1. install node/npm
2. clone repo
3. npm install


to develop
----------

add and edit files in the source directory

these files are compiled/copied to the target directory by the grunt task (see build section below)

do not commit any files created in directories other than src


to build
--------

to detect changes in src files and build to the target directory:

node node_modules/grunt-cli/bin/grunt

you may need to touch one of the files to trigger an initial build.

to compile app and deploy to phone:

cd phonegap && node ../node_modules/phonegap/bin/phonegap.js run android






