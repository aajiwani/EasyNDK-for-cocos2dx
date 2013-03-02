//
//  IOSNDKHelper.h
//  EasyNDK-for-cocos2dx
//
//  Created by Amir Ali Jiwani on 23/02/2013.
//
//

#ifndef __EasyNDK_for_cocos2dx__IOSNDKHelper__
#define __EasyNDK_for_cocos2dx__IOSNDKHelper__

#import "IOSNDKHelper-C-Interface.h"

@interface IOSNDKHelper : NSObject

+ (void) SetNDKReciever:(NSObject*)reciever;
+ (void) SendMessage:(NSString*)methodName WithParameters:(NSDictionary*)prms;

@end

#endif /* defined(__EasyNDK_for_cocos2dx__IOSNDKHelper__) */