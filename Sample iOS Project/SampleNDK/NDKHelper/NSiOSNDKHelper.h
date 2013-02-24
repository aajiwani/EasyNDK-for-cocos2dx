//
//  NSiOSNDKHelper.h
//  FeedGarfield
//
//  Created by Muhammed Ali Khan on 10/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "jansson.h"
#include "RootViewController.h"
#include "PLGameCenterManager.h"
#include "InAppPurchaseManager.h"
#include "InAppConstants.h"

#define CONVERTER_CSTRING_TO_NSSTRING_UTF8(__x__)                [NSString stringWithUTF8String:__x__]


@interface GF_AutoReleasePool : NSObject
{
    NSMutableArray *resources;
    
}

+ (GF_AutoReleasePool*) getInstance;
+ (void) releaseInstance;
- (void) addToPool:(NSObject*)obj;
- (void) releasePool;
@end


@interface NSiOSNDKHelper : NSObject <PLGameCenterManagerDelegate, UIAlertViewDelegate>
{
    PLGameCenterManager *_gameCenterManager;
    
    UIWindow *_window;
    
    UISwitch *_soundSwitchButton;
    UISwitch *_musicSwitchButton;
    UISwitch *_resetGameSwitchButton;
    UIActivityIndicatorView * _inAppLoadingActivityIndicator;
}

-(NSiOSNDKHelper*) init;
+(void) SendMessage:(NSString*)methodName WithParameters:(NSDictionary*)prms;

#pragma mark -
#pragma mark Global Functions

-(void) OpenFacebookPage:(NSObject*)prms;
-(void) OpenUrl:(NSObject*)prms;
-(void) ShowOkDialogView:(NSObject*) prms;
-(void) PurchaseAllBackgrounds:(NSObject*) prms;
-(void) RestoreInApp:(NSObject*) prms;
-(void) prepareForRecievingNotifications;
-(void) receivePurchaseNotification:(NSNotification *) notification;
-(void) removeNotifcationObserver;


#pragma mark -
#pragma mark Game Center

-(void) AuthenticateGameCenterPlayer:(NSObject *)prms;
-(void) ShowGameCenterLeaderBoard:(NSObject *)prms;
-(void) SubmitScore:(NSObject *)prms;

#pragma mark -
#pragma mark Settings method
-(void) AddSettingSwitchButtons:(NSObject*)prms;
-(void) RemoveSwitchButtons:(NSObject*)prms;
-(void) onSoundSwitchStateChange;
-(void) onMusicSwitchStateChange;
-(void) onResetGameSwitchStateChange:(NSObject*)prams;

-(void) ShowConfirmUnlockGameBackgroundDialog:(NSObject*) prms;

-(void) showActivityIndicator:(NSObject*) prms;
-(void) removeActivityIndicator:(NSObject*) prms;

-(void) DoSomething:(NSObject*) prms;

@end
