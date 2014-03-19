//
//  NDKCallbackNode.h
//  EasyNDK-for-cocos2dx
//
//  Created by Amir Ali Jiwani on 23/02/2013.
//
//

#ifndef __EasyNDK_for_cocos2dx__NDKCallbackNode__
#define __EasyNDK_for_cocos2dx__NDKCallbackNode__

#include "cocos2d.h"
#include <string>
USING_NS_CC;
using namespace std;

class NDKCallbackNode
{
    private :
    SEL_CallFuncO sel;
    string name;
    string groupName;
    CCObject *target;
    
    public :
    NDKCallbackNode(const char *groupName, const char *name, SEL_CallFuncO sel, CCObject *target);
    string getName();
    string getGroup();
    SEL_CallFuncO getSelector();
    CCObject* getTarget();
};

#endif /* defined(__EasyNDK_for_cocos2dx__NDKCallbackNode__) */
