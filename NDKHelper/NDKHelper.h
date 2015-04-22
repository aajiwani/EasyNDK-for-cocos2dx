//
//  NDKHelper.h
//  EasyNDK-for-cocos2dx
//
//  Created by Amir Ali Jiwani on 23/02/2013.
//	Modified by Naël MSKINE on 19/03/2014
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

class NDKHelper : public CCObject
{
public :
	static NDKHelper *SharedHelper();
	static void DestroyHelper();

	static CCObject* GetCCObjectFromJson(json_t *obj);
	static json_t* GetJsonFromCCObject(CCObject* obj);

    void AddSelector(const char *groupName, const char *name, SEL_CallFuncO selector, CCObject* target);
    void RemoveSelectorsInGroup(char *groupName);
    void PrintSelectorList();
	void HandleMessage(json_t *methodName, json_t* methodParams);

protected:
	CREATE_FUNC(NDKHelper);
	virtual bool init();
	virtual ~NDKHelper();
	void RemoveAtIndex(int index);
	void ExecuteCallfuncs(float dt);

protected:
	static NDKHelper *_sharedHelper;
	vector<NDKCallbackNode> selectorList;
	CCArray *callfuncs;
};

extern "C"
{
    void SendMessageWithParams(string methodName, CCObject* methodParams);
}

#endif /* defined(__EasyNDK_for_cocos2dx__NDKHelper__) */
