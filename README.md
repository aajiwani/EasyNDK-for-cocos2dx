EasyNDK-for-cocos2dx
====================

NDK in cocos2dx is a problem, most of the developers don't want that pain to slow down there process of game making.
While i wanted to port a game made on cocos2dx from iOS to Android it did without any mess, but when it came to
working with native features like GameCenter on iOS and AppCircle for Android(Amazon) it was a pain to write 
conditional code and do mess with both C++ and Objective C (ios) and Android (java) files.

From that pain i learned alot and finally created a hassle free library to integrate both platform with a breeze.

I found that json is a great data language with which one can easily transfer their data structures across platforms,
be it web or be it languages that we work in our daily lives.

I have created this library with just string usage, you can parse json in almost any language for smart phones.
With json i can transfer structures without any need to create them on both ends that is C++ and the native platform.

Currenty, I am not parsing dates in json. Current parser is ok to parse, dictionary, array, boolean, int, real and string


Q.) How it works ?
A.) It works on a protocol which is simple to be understood. In any particular environment, on init of it, specify
    the reciever that can listen messages sent from C++. Second, remaining on a particular CCNode in Cocos2dx C++ file,
    register global selectors that will respond to NDK calls from native platform, for the ease of use i have used
    groups. So that on leaving that particular scene of layer or at any instance you can remove the whole group,
    instead of deleting each item individually. After the above requirements are met, simply compose CCObject* that is
    CCDictionary from C++ as parameters to be sent and a string that would contain the name of the method sent to native
    platform. In the native platform you can simply have method names exactly like the message you sent for the simplicity.
    You will get the native type of parameters that is NSDictionary* in iOS and JSONObject in Android. Similarly you can
    pass a message from native to C++ platform, by composing a NSDictionary or JSONObject with a method name, this method
    name would be checked for the selector string that you have already registered with, and on C++ you will get hit on
    that selector once the message occurs. You will get CCDictionary* in C++ environment.
