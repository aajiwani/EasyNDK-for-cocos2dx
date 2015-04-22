//
//  NDKCallbackNode.cpp
//  EasyNDK-for-cocos2dx
//
//  Created by Amir Ali Jiwani on 23/02/2013.
//
//

#include "NDKCallbackNode.h"

NDKCallbackNode::NDKCallbackNode(const char *groupName, const char *name, SEL_CallFuncO sel, CCObject *target)
{
    this->groupName = groupName;
    this->name = name;
    this->sel = sel;
    this->target = target;
}

string NDKCallbackNode::getName()
{
    return this->name;
}

string NDKCallbackNode::getGroup()
{
    return this->groupName;
}

SEL_CallFuncO NDKCallbackNode::getSelector()
{
    return this->sel;
}

CCObject* NDKCallbackNode::getTarget()
{
    return this->target;
}