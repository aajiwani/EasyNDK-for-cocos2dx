//
//  IOSNDKHelper-C-Interface.h
//  EasyNDK-for-cocos2dx
//
//  Created by Amir Ali Jiwani on 23/02/2013.
//
//

#ifndef EasyNDK_for_cocos2dx_IOSNDKHelper_C_Interface_h
#define EasyNDK_for_cocos2dx_IOSNDKHelper_C_Interface_h

#include <iostream>
#include "cocos2d.h"
#include "jansson.h"
#include <string>
USING_NS_CC;
using namespace std;

class IOSNDKHelperImpl
{
    public :
        IOSNDKHelperImpl();
        ~IOSNDKHelperImpl();
        static void RecieveCPPMessage(json_t *methodName, json_t* methodParams);
        static void SetNDKReciever(void* reciever);
};

#endif
