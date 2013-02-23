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
```
A.) It works on a protocol which is simple to be understood. In any particular environment, on init of it, specify
    the reciever that can listen messages sent from C++. Second, remaining on a particular CCNode in Cocos2dx C++ file,
    register global selectors that will respond to NDK calls from native platform, for the ease of use i have used
    groups. So that on leaving that particular scene of layer or at any instance you can remove the whole group,
    instead of deleting each item individually. After the above requirements are met, simply compose CCObject that is
    CCDictionary from C++ as parameters to be sent and a string that would contain the name of the method sent to native
    platform. In the native platform you can simply have method names exactly like the message you sent for the simplicity.
    You will get the native type of parameters that is NSDictionary* in iOS and JSONObject in Android. Similarly you can
    pass a message from native to C++ platform, by composing a NSDictionary or JSONObject with a method name, this method
    name would be checked for the selector string that you have already registered with, and on C++ you will get hit on
    that selector once the message occurs. You will get CCDictionary in C++ environment.
```


Diagram :

```

                ==>                  ==> Communication Loop             ==>    Remove C++
Assign          ==>     C++          ==> C++ -> Native (Message)        ==> Selector Groups
Native Reciever ==> Assign Selectors ==> Native Method Call             ==>
                ==> In Groups        ==> Native -> C++ (Message)        ==>  Remove Native
                ==>                  ==> C++ Selector Call (Cocos2dx)   ==>    Reciever
```
                
                
Under the hood, when you pass a message either from C++ or Native, the message is converted to a JSON string using a C
Library namely Jansson (http://www.digip.org/jansson/), licensed under MIT. There are helper method written to convert 
the data from CCDictionary to JSON and from JSON to CCDictionary.

This is the basics of how this helper works.

For details of individual platforms source contains the respective folder

```

/jansson                            => Contains the C Library Jansson (http://www.digip.org/jansson/)

/NDKHelper
    /NDKCallbackNode.h              => C++ Class, to work as a node, that contains selector info that would be assigned from C++ to the global space
    /NDKCallbackNode.cpp            => Implementation of NDKCallbackNode
    /NDKHelper.h                    => Main NDKHelper class for to send and recieve messages from and to C++, for iOS and Android currently
    /NDKHelper.cpp                  => Implementation of NDKHelper
    
/ios
    /RootViewController.h           => Sample ios controller to recieve and send messages to C++
    /RootViewController.mm          => Implementation of RootViewController
    
/Classes
    /HelloWorldScene.h              => A basic scene from cocos2dx sample, including a selector to respond to native environment message
    /HelloWorldScene.cpp            => Implementation of HelloWorldScene

/android
    

/IOSNDKHelper
    /IOSNDKHelper-C-Interface.h     => C header for IOS to attach a reciever and send message to C++
    /IOSNDKHelper.h                 => Objective C wrapper for NDKHelper in iOS
    /IOSNDKHelper.mm                => Implementation of IOSNDKHelper
```

Sample Scenario :

```
You are working on a game which have a submit score button, now you are using game center on ios and someother third party
tool on android. If you will write your NDK code you might need to write it seperately and with many #if checks, from the 
above made protocol, you can simply issue a message of submitting score and send score as a parameter, and on different 
platforms ios and android write respectively different codes to handle it (Objc and Java). You simply have to watch for 
a specific message on both platforms. And with the above library you can do it without any hassle. Publishing builds on
different platforms would become breeze.

Try It, and comment. Please do let me know what this library can be improved. Thankyou.
```
