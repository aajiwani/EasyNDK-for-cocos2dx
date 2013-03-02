//
//  NDKHelper.h
//  EasyNDK-for-cocos2dx
//
//  Created by Amir Ali Jiwani on 23/02/2013.
//
//

#ifndef __EasyNDK_for_cocos2dx__NDKHelper__
#define __EasyNDK_for_cocos2dx__NDKHelper__

#include <iostream>
#include "cocos2d.h"
#include <string>
#include <vector>
#include "jansson.h"
#include "NDKCallbackNode.h"
USING_NS_CC;
using namespace std;

class NDKHelper
{
    private :
        static vector<NDKCallbackNode> selectorList;
        //static CCDictionary* GetDict(json_t *dictionary);
        static void RemoveAtIndex(int index);

    public :
        static void AddSelector(const char *groupName, const char *name, SEL_CallFuncND selector, CCNode* target);
        static void RemoveSelectorsInGroup(char *groupName);
        static void PrintSelectorList();
        static CCObject* GetCCObjectFromJson(json_t *obj);
        static json_t* GetJsonFromCCObject(CCObject* obj);
        static void HandleMessage(json_t *methodName, json_t* methodParams);
};

extern "C"
{
    void SendMessageWithParams(string methodName, CCObject* methodParams);
}

#endif /* defined(__EasyNDK_for_cocos2dx__NDKHelper__) */
