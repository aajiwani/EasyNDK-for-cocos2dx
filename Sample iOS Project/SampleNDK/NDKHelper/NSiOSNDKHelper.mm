//
//  NSiOSNDKHelper.m
//  FeedGarfield
//
//  Created by Muhammed Ali Khan on 10/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSiOSNDKHelper.h"
#import "iOSNDKHelper.h"
#import "NDKHelper.h"
#import "AppController.h"

static GF_AutoReleasePool *instance;

@implementation GF_AutoReleasePool

+ (GF_AutoReleasePool*) getInstance
{
    if (instance == nil)
    {
        instance = [[GF_AutoReleasePool alloc] init];
    }
    return instance;
}

+ (void) releaseInstance
{
    if (instance != nil)
    {
        [instance release];
        instance = nil;
    }
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        resources = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void) addToPool:(NSObject*)obj
{
    [resources addObject:obj];
}

- (void) releasePool
{
    for (int i = 0; i < [resources count]; i++)
    {
        NSObject *obj = [resources objectAtIndex:i];
        [obj release];
        obj = nil;
    }
}

- (void)dealloc
{
    [instance release];
    instance = nil;
    
    [resources release];
    resources = nil;
    
    [super dealloc];
}

@end

@interface NSiOSNDKHelper (Private)

@end

@implementation NSiOSNDKHelper

-(NSiOSNDKHelper*) init
{
    if(self = [super init])
    {
        _window = [[UIApplication sharedApplication] keyWindow];
        _gameCenterManager = [[PLGameCenterManager alloc] init];
        _gameCenterManager.delegate = self;
    }
    return self;
}

-(void)dealloc
{
    _window = nil;
    [_gameCenterManager release];
    [super dealloc];
}

+(void) SendMessage:(NSString*)methodName WithParameters:(NSDictionary*)prms
{
    json_t* jsonMethod = json_string([methodName UTF8String]);
    json_t *jsonPrms = NULL;
    
    if (prms != nil)
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:prms
                            options:NSJSONWritingPrettyPrinted
                            error:&error];
        
        if (error != nil)
            return;
        
        NSString *jsonPrmsString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
        
        json_error_t jerror;
        jsonPrms = json_loads([jsonPrmsString UTF8String], 0, &jerror);
        
        if (!jsonPrms)
        {
            fprintf(stderr, "error: on line %d: %s\n", jerror.line, jerror.text);
            return;
        }
        
        [jsonPrmsString release];
        jsonPrmsString = nil;
    }
    
    NDKHelper::HandleMessage(jsonMethod, jsonPrms);
    json_decref(jsonMethod);
    
    if (jsonPrms)
        json_decref(jsonPrms);
}


#pragma mark -
#pragma mark Global Functions

-(void)OpenFacebookPage:(NSObject*)prms
{
    NSDictionary *parameters = (NSDictionary*)prms;
    NSString *fbKey = [parameters valueForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(FACEBOOK_PROFILE_ID_KEY)];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]])
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", fbKey]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://m.facebook.com/%@", fbKey]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)OpenUrl:(NSObject *)prms
{
    NSDictionary *parameters = (NSDictionary*)prms;
    NSString *browseUrl = [parameters valueForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(BROWSE_URL_KEY)];
    
    if([[UIApplication sharedApplication] openURL:[NSURL URLWithString:browseUrl]] == false)
    {
        NSDictionary *alertDialogParameters = [NSDictionary dictionaryWithObjectsAndKeys:@"Invalid url.", CONVERTER_CSTRING_TO_NSSTRING_UTF8(OK_ALERT_DIALOG_VIEW_MESSAGE_KEY), nil];
        [self ShowOkDialogView:alertDialogParameters];
    }
}

-(void) ShowOkDialogView:(NSObject *)prms
{
    NSDictionary *parameters = (NSDictionary*)prms;
    NSString *message = [parameters valueForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(OK_ALERT_DIALOG_VIEW_MESSAGE_KEY)];
    
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertDialog show];
    [alertDialog release];
    
}

-(void) PurchaseAllBackgrounds:(NSObject *)prms
{
    NSLog(@"purchase something called");
    NSDictionary *parameters = (NSDictionary*)prms;
    NSString *message = [parameters valueForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(PURCHASE_ALL_BACKGROUNDS_ID_KEY)];
    
    NSLog(@"purchaising this: %@", message);
    // Attaching Listeners
	[self prepareForRecievingNotifications];
	
	// Store
	InAppPurchaseManager *manager = [InAppPurchaseManager sharedInAppManager];
	
	// Load & Buy
	[manager loadStore];
    
    [InAppPurchaseManager sharedInAppManager].callerID = self;
    manager = [InAppPurchaseManager sharedInAppManager];
    [manager purchaseProductWithIdentifier:message];
    
    
}

-(void) RestoreInApp:(NSObject *)prms
{
    NSLog(@"Restore In App called");
    
    // Attaching Listeners
	[self prepareForRecievingNotifications];
	
    [InAppPurchaseManager sharedInAppManager].callerID = self;
    InAppPurchaseManager *myMan = [InAppPurchaseManager sharedInAppManager];
    
    [myMan restoreCompletedTransactions];
}

-(void) prepareForRecievingNotifications
{
	NSLog(@"Store::prepareForReceivingNotifications");
	
	// Delegate
	[InAppPurchaseManager sharedInAppManager].callerID = self;
	
	// Listen for store requests notifications.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(receivePurchaseNotification:)
												 name:INAPP_NOTIF_REQ_COMPLETED
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(receivePurchaseNotification:)
												 name:INAPP_NOTIF_REQ_CANCELLED
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(receivePurchaseNotification:)
												 name:INAPP_NOTIF_REQ_FAILED
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(receivePurchaseNotification:)
												 name:INAPP_NOTIF_RESTORE_COMPLETED
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(receivePurchaseNotification:)
												 name:INAPP_NOTIF_RESTORE_FAILED
											   object:nil];
	
	// Store Loaded Selector
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(receivePurchaseNotification:)
												 name:INAPP_NOTIF_STORE_LOAD_COMPLETED
											   object:nil];
}

// Receiver
-(void) receivePurchaseNotification:(NSNotification *) notification
{
	NSLog(@"Store:: receivePurchaseNotification");
	
	if ([[notification name] isEqualToString:INAPP_NOTIF_STORE_LOAD_COMPLETED])
	{
		if ([[InAppPurchaseManager sharedInAppManager] storeLoaded])
		{
			// Update the UI to show that the store has loaded, i.e. the user can make a purchase
			NSLog(@"Store Load request completed.");
			return;
		}
	}
	else if ([[notification name] isEqualToString:INAPP_NOTIF_REQ_CANCELLED])
	{
		NSLog(@"Request Cancelled");
        
        NSDictionary *restoreData = notification.object;
        NSString* idOfProducts = [restoreData objectForKey:@"purchasedproductidentifier"];
        NSLog(@"idOfProducts %@", idOfProducts);
        [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_INAPP_RESPONSE_SELECTOR) WithParameters:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:true],
                                    CONVERTER_CSTRING_TO_NSSTRING_UTF8(INAPP_NOTIF_REQ_KEY),                                                                                                                   idOfProducts,                                                                                                                   CONVERTER_CSTRING_TO_NSSTRING_UTF8(INAPP_RESTORE_PRODUCT_IDS_KEY),nil]];
	}
	else if ([[notification name] isEqualToString:INAPP_NOTIF_RESTORE_COMPLETED])
	{
		NSLog(@"Restored");
        NSDictionary *restoreData = notification.userInfo;
        NSArray* idOfProducts = [restoreData objectForKey:@"PaymentQueue"];
        
        [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_INAPP_RESPONSE_SELECTOR) WithParameters:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:true],
                                   CONVERTER_CSTRING_TO_NSSTRING_UTF8(INAPP_RESTORE_DONE_KEY),
                                   idOfProducts,
                                   CONVERTER_CSTRING_TO_NSSTRING_UTF8(INAPP_RESTORE_PRODUCT_IDS_KEY),
                                   nil]];
    }
	else if ([[notification name] isEqualToString:INAPP_NOTIF_RESTORE_FAILED])
	{
		// hide the activity UI
		[[[[UIAlertView alloc] initWithTitle:@"Store Error"
									 message:@"Sorry. Seems like something went wrong, please try again later."
									delegate:nil
						   cancelButtonTitle:@"OK"
						   otherButtonTitles:nil] autorelease] show];
		
		NSLog(@"Restore Failed");
        [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_INAPP_RESPONSE_SELECTOR) WithParameters:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:false],CONVERTER_CSTRING_TO_NSSTRING_UTF8(INAPP_RESTORE_DONE_KEY), nil]];
		
	}
    else if ([[notification name] isEqualToString:INAPP_NOTIF_REQ_FAILED])
	{
		[[[[UIAlertView alloc] initWithTitle:@"Store Error"
									 message:@"Sorry. Seems like something went wrong, please try again later."
									delegate:nil
						   cancelButtonTitle:@"OK"
						   otherButtonTitles:nil] autorelease] show];
		
		NSLog(@"Request Failed:");
        [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_INAPP_RESPONSE_SELECTOR) WithParameters:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:false],CONVERTER_CSTRING_TO_NSSTRING_UTF8(INAPP_PURCHASED_DONE_KEY), nil]];
		
	}
	else if ([[notification name] isEqualToString:INAPP_NOTIF_REQ_COMPLETED])
	{
		
		[[[[UIAlertView alloc] initWithTitle:@"Store Confirmation"
									 message:@"Thankyou. You have purchased all the backgrounds of Moustache Slap."
									delegate:nil
						   cancelButtonTitle:@"OK"
						   otherButtonTitles:nil] autorelease] show];
		
		NSLog(@"Purchase Successfull");
        
        NSDictionary *restoreData = notification.userInfo;
        NSString* idOfProducts = [restoreData objectForKey:@"purchasedproductidentifier"];
        
        [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_INAPP_RESPONSE_SELECTOR) WithParameters:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:true],
                                    CONVERTER_CSTRING_TO_NSSTRING_UTF8(INAPP_PURCHASED_DONE_KEY),                                                                                                                   idOfProducts,                                                                                                                   CONVERTER_CSTRING_TO_NSSTRING_UTF8(INAPP_RESTORE_PRODUCT_IDS_KEY),                                                                                                                   nil]];
		
		// Purchase Successfull
		
		// Done
//		[self onReleaseCancel];
	}
	
	// Restoring Cancel Button
//	[self onReleaseCancel];
	
	[self removeNotifcationObserver];
}

-(void) removeNotifcationObserver
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Game Center

-(void) AuthenticateGameCenterPlayer:(NSObject *)prms
{
    if([PLGameCenterManager IsGameCenterAvailable])
    {
        [_gameCenterManager AuthenticateLocalUser];
    }
}

-(void)didAuthorized
{
    NSLog(@"GameCenter Player Authorized --> Success");
}

-(void)authorizationFailed:(NSError *)error
{
    NSLog(@"GameCenter Player Authorized --> %@", [error localizedDescription]);
}

-(void) ShowGameCenterLeaderBoard:(NSObject *)prms
{
    if([PLGameCenterManager IsGameCenterAvailable])
    {
       [_gameCenterManager ShowGameCenterLeaderBoard:_window.rootViewController];
    }
}

-(void)leaderboardViewControllerDismissed
{
    NSLog(@"leader board dismissed");
}

-(void) SubmitScore:(NSObject *)prms
{
    NSDictionary* parameters = (NSDictionary*)prms;
    NSString *leaderboardCategoryId = [parameters valueForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(LEADER_BOARD_CATEGORY_ID_KEY)];
    int64_t leaderboardScore = [[parameters valueForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(LEADER_BOARD_SCORE_KEY)] intValue];
    
    if([PLGameCenterManager IsGameCenterAvailable])
    {
        [_gameCenterManager SubmitScore: leaderboardCategoryId withScore: leaderboardScore];
    }
}

-(void)didScoreSubmitted
{
    NSLog(@"Game Center Score --> Submitted");
}

-(void)scoreSubmissionFailed:(NSError *)error
{
    NSLog(@"Game Center Score Failed --> %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark Settings method

-(void) AddSettingSwitchButtons:(NSObject *)prms
{
    NSArray *recvPrams = (NSArray*)prms;
    
    NSDictionary *switchButtonInfo = [recvPrams objectAtIndex: 0];
    int xSoundPosition = [[switchButtonInfo objectForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(X_POSITION_SWITCH_BUTTON_KEY)] intValue];
    int ySoundPosition = [[switchButtonInfo objectForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(Y_POSITION_SWITCH_BUTTON_KEY)] intValue];
    BOOL soundValue = [[switchButtonInfo objectForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(VALUE_SWITCH_BUTTON_KEY)] boolValue];
    
    _soundSwitchButton= [[UISwitch alloc] initWithFrame:CGRectMake(xSoundPosition, ySoundPosition, 10, 10)];
    [_soundSwitchButton setOn:soundValue];
    [_soundSwitchButton addTarget:self action:@selector(onSoundSwitchStateChange) forControlEvents:UIControlEventValueChanged];
    _soundSwitchButton.alpha = 0.0f;
    [_window.rootViewController.view addSubview:_soundSwitchButton];
    
    NSLog(@"Switch Btn Size : (%.2f, %.2f)", _soundSwitchButton.frame.size.width, _soundSwitchButton.frame.size.height);
    
    NSDictionary *musicButtonInfo = [recvPrams objectAtIndex: 1];
    int xMusicPosition = [[musicButtonInfo objectForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(X_POSITION_SWITCH_BUTTON_KEY)] intValue];
    int yMusicPosition = [[musicButtonInfo objectForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(Y_POSITION_SWITCH_BUTTON_KEY)] intValue];
    BOOL musicValue = [[musicButtonInfo objectForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(VALUE_SWITCH_BUTTON_KEY)] boolValue];
    
    _musicSwitchButton = [[UISwitch alloc] initWithFrame:CGRectMake(xMusicPosition, yMusicPosition, 10, 10)];
    [_musicSwitchButton setOn:musicValue];
    [_musicSwitchButton addTarget:self action:@selector(onMusicSwitchStateChange) forControlEvents:UIControlEventValueChanged];
    _musicSwitchButton.alpha = 0.0f;
    [_window.rootViewController.view addSubview:_musicSwitchButton];
    
    NSDictionary *resetGameButtonInfo = [recvPrams objectAtIndex: 2];
    int xResetGamePosition = [[resetGameButtonInfo objectForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(X_POSITION_SWITCH_BUTTON_KEY)] intValue];
    int yResetGamePosition = [[resetGameButtonInfo objectForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(Y_POSITION_SWITCH_BUTTON_KEY)] intValue];
    BOOL resetGameValue = [[resetGameButtonInfo objectForKey:CONVERTER_CSTRING_TO_NSSTRING_UTF8(VALUE_SWITCH_BUTTON_KEY)] boolValue];
    
    _resetGameSwitchButton = [[UISwitch alloc] initWithFrame:CGRectMake(xResetGamePosition, yResetGamePosition, 10, 10)];
    [_resetGameSwitchButton setOn:resetGameValue];
    [_resetGameSwitchButton addTarget:self action:@selector(onResetGameSwitchStateChange) forControlEvents:UIControlEventValueChanged];
    _resetGameSwitchButton.alpha = 0.0f;
    [_window.rootViewController.view addSubview:_resetGameSwitchButton];
    
    [UIView animateWithDuration:SWITCH_BUTTON_ALPHA_TRANSITION_DURATION+.4f animations:^{
        _soundSwitchButton.alpha = 1.0f;
    }];

    [UIView animateWithDuration:SWITCH_BUTTON_ALPHA_TRANSITION_DURATION+.4f animations:^{
        _musicSwitchButton.alpha = 1.0f;
    }];
    
    [UIView animateWithDuration:SWITCH_BUTTON_ALPHA_TRANSITION_DURATION+.4f animations:^{
        _resetGameSwitchButton.alpha = 1.0f;
    }];
}



-(void)RemoveSwitchButtons:(NSObject *)prms
{
    [UIView animateWithDuration:SWITCH_BUTTON_ALPHA_TRANSITION_DURATION animations:^{
        _soundSwitchButton.alpha = 0.0f;
    } completion:^(BOOL ){
        [_soundSwitchButton removeFromSuperview];
        [_soundSwitchButton release];
        _soundSwitchButton = nil;
    }];
    
    [UIView animateWithDuration:SWITCH_BUTTON_ALPHA_TRANSITION_DURATION animations:^{
        _musicSwitchButton.alpha = 0.0f;
    } completion:^(BOOL ){
        [_musicSwitchButton removeFromSuperview];
        [_musicSwitchButton release];
        _musicSwitchButton = nil;
    }];
    

    
    [UIView animateWithDuration:SWITCH_BUTTON_ALPHA_TRANSITION_DURATION animations:^{
        _resetGameSwitchButton.alpha = 0.0f;
    } completion:^(BOOL ){
        [_resetGameSwitchButton removeFromSuperview];
        [_resetGameSwitchButton release];
        _resetGameSwitchButton = nil;
    }];
}

-(void)onSoundSwitchStateChange
{
    bool isSoundEnable = [_soundSwitchButton isOn];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:isSoundEnable], CONVERTER_CSTRING_TO_NSSTRING_UTF8(VALUE_SWITCH_BUTTON_KEY), nil];
    
    [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_SOUND_SWITCH_BUTTON_STATE_CHANGE_SELECTOR) WithParameters:parameters];
}

-(void)onMusicSwitchStateChange
{
    bool isMusicEnable = [_musicSwitchButton isOn];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:isMusicEnable], CONVERTER_CSTRING_TO_NSSTRING_UTF8(VALUE_SWITCH_BUTTON_KEY), nil];
    
    [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_MUSIC_SWITCH_BUTTON_STATE_CHANGE_SELECTOR) WithParameters:parameters];
}

-(void)onResetGameSwitchStateChange:(NSObject*)prams
{
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"Reset Game" message:CONVERTER_CSTRING_TO_NSSTRING_UTF8(RESET_SWITCH_STATE_CHANGE_MESSAGE) delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alertDialog setTag:RESET_APPLICATION_ALERT_VIEW_TAG];
    [alertDialog show];
    [alertDialog release];
}

-(void)ShowConfirmUnlockGameBackgroundDialog:(NSObject*)prams
{
    NSDictionary *prmsDict = (NSDictionary*)prams;
    NSString* messageToShow = (NSString*)[prmsDict objectForKey:@"message"];
    NSString* titleToShow = (NSString*)[prmsDict objectForKey:@"messagetitle"];
    
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:titleToShow message:messageToShow delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alertDialog setTag:UNLOCK_GAME_BACKGROUND_ALERT_VIEW_TAG];
    [alertDialog show];
    [alertDialog release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // check is alert dialog for unlock game background or not
    if([alertView tag] == UNLOCK_GAME_BACKGROUND_ALERT_VIEW_TAG)
    {
        if(buttonIndex == 0)
        {
            // no
            [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_UNLOCK_GAME_BACKGROUND_DIALOG_NO_SELECTOR) WithParameters:[NSDictionary dictionary]];
        }
        else
        {
            // yes
            [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_UNLOCK_GAME_BACKGROUND_DIALOG_YES_SELECTOR) WithParameters:[NSDictionary dictionary]];
        }
    }
    else if([alertView tag] == RESET_APPLICATION_ALERT_VIEW_TAG)
    {
        if(buttonIndex == 0)
        {
            // no
            [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_RESET_GAME_DIALOG_NO_SELECTOR) WithParameters:[NSDictionary dictionary]];
        }
        else
        {
            // yes
            [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(ON_RESET_GAME_DIALOG_YES_SELECTOR) WithParameters:[NSDictionary dictionary]];
        }
        [_resetGameSwitchButton setOn:NO animated:YES];
    }
}

-(void) showActivityIndicator:(NSObject*) prms
{
    _inAppLoadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    AppController *currentApp = (AppController*)[[UIApplication sharedApplication] delegate];
    
    float screenWidth = [currentApp viewController].view.frame.size.width;
    float screenHeight = [currentApp viewController].view.frame.size.height;
    
    [_inAppLoadingActivityIndicator setCenter:CGPointMake(screenHeight/2-5, screenWidth/2-5)];
    [_inAppLoadingActivityIndicator setContentMode:UIViewContentModeCenter];
    
    [[currentApp viewController].view addSubview:_inAppLoadingActivityIndicator];
    [_inAppLoadingActivityIndicator startAnimating];
}

-(void) removeActivityIndicator:(NSObject*) prms
{
    [_inAppLoadingActivityIndicator stopAnimating];
    [_inAppLoadingActivityIndicator removeFromSuperview];
    [_inAppLoadingActivityIndicator release];
    _inAppLoadingActivityIndicator = nil;
    
}

-(void) DoSomething:(NSObject*)prms
{
    NSDictionary *recievedParams = (NSDictionary*)prms;
    NSLog(@"Recieved Dictionary : %@", recievedParams);
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Wallpaper Success"
                          message: @"Wallpaper saved to your photo album, you can now use it as your wallpaper."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    NSDictionary *dictionary = [[NSDictionary alloc]
                                initWithObjectsAndKeys:@"object1",
                                @"key1",
                                [NSArray arrayWithObjects:@"1", @"2", nil],
                                @"key2",
                                nil];
    
    [NSiOSNDKHelper SendMessage:CONVERTER_CSTRING_TO_NSSTRING_UTF8(NDK_RM_SAVE_WALLPAPER_DONE) WithParameters:dictionary];
}
@end
