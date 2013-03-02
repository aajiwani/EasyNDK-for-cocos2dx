//
//  NDKConstants.h
//  TestCCProjOne
//
//  Created by Pi Labs on 25/10/2012.
//
//

#ifndef TestCCProjOne_NDKConstants_h
#define TestCCProjOne_NDKConstants_h

#define NDK_SM_BUYITEM                                           "BuyItem"
#define NDK_SM_SAVE_WALLPAPER                                    "SaveWallpaper"

#define NDK_RM_CPP_MESSAGE                                       "CPPMessage"
#define NDK_RM_SAVE_WALLPAPER_DONE                               "SaveWallpaperDone"

#pragma mark -
#pragma mark Global Functions Constants


#define OBJ_C_FUNC_OPEN_URL                                      "OpenUrl"
#define OBJ_C_FUNC_OPEN_FB_PAGE                                  "OpenFacebookPage"
#define OBJ_C_FUNC_PURCHASE_ALL_BACKGROUNDS                      "PurchaseAllBackgrounds"
#define OBJ_C_FUNC_RESTORE_INAPP                                 "RestoreInApp"
#define OBJ_C_FUNC_SHOW_OK_DIALOG_VIEW                           "ShowOkDialogView"
#define OK_ALERT_DIALOG_VIEW_TITLE_KEY                           "AlertDialogTitle"
#define OK_ALERT_DIALOG_VIEW_MESSAGE_KEY                         "AlertDialogMessage"

#define BROWSE_URL_KEY                                           "BrowseURL"
#define FACEBOOK_PROFILE_ID_KEY                                  "FB-ID"
#define PURCHASE_ALL_BACKGROUNDS_ID_KEY                          "purchase_all_backgrounds"

// final id : com.appster.slapapp.purchaseallbackgrounds
#define INAPP_ALL_BACKGROUNDS_ID                                 "com.appster.slapapp.purchaseallbackgrounds"

#define INAPP_PURCHASED_DONE_KEY                                 "purchased_done"
#define INAPP_NOTIF_REQ_KEY                                      "notif_req"
#define INAPP_RESTORE_DONE_KEY                                   "restore_done"
#define INAPP_RESTORE_PRODUCT_IDS_KEY                            "restore_product_ids"

#pragma mark -
#pragma mark Setting Layer

#define ON_SOUND_SWITCH_BUTTON_STATE_CHANGE_SELECTOR             "OnSoundSwitchButtonStateChange"
#define ON_MUSIC_SWITCH_BUTTON_STATE_CHANGE_SELECTOR             "OnMusicSwitchButtonStateChange"
#define ON_RESET_GAME_SWITCH_BUTTON_STATE_CHANGE_SELECTOR        "OnResetGameSwitchButtonStateChange"
#define ON_UNLOCK_GAME_BACKGROUND_DIALOG_YES_SELECTOR            "OnReleaseUnlockGameBackgroundDialogYes"
#define ON_UNLOCK_GAME_BACKGROUND_DIALOG_NO_SELECTOR             "OnReleaseUnlockGameBackgroundDialogNo"

#define ON_RESET_GAME_DIALOG_YES_SELECTOR                        "onReleaseResetGameDialogYes"
#define ON_RESET_GAME_DIALOG_NO_SELECTOR                         "onReleaseResetGameDialogNo"

#define ON_INAPP_RESPONSE_SELECTOR                               "onInAppResponse"

#define SETTING_LAYER_GROUP_KEY                                  "SettingLayerSelectors"

#define OBJ_C_FUNC_ADD_SWITCH_BUTTON                             "AddSettingSwitchButtons"
#define OBJ_C_FUNC_REMOVE_SWITCH_BUTTON                          "RemoveSwitchButtons"
#define OBJ_C_FUNC_SHOW_CONFIRM_UNLOCK_GAME_BACKGROUD_DIALOG     "ShowConfirmUnlockGameBackgroundDialog"
#define OBJ_C_FUNC_ON_ENTER_BACKGROUND                           "onEnterBackground"
#define OBJ_C_FUNC_SHOW_ACTIVITY_INDICATOR                       "showActivityIndicator"
#define OBJ_C_FUNC_REMOVE_ACTIVITY_INDICATOR                     "removeActivityIndicator"

#define X_POSITION_SWITCH_BUTTON_KEY                             "xPosition"
#define Y_POSITION_SWITCH_BUTTON_KEY                             "yPosition"
#define VALUE_SWITCH_BUTTON_KEY                                  "SwitchValue"

#define SWITCH_BUTTON_ALPHA_TRANSITION_DURATION                  0.4f
#define UNLOCK_GAME_BACKGROUND_ALERT_VIEW_TAG                    9875
#define RESET_APPLICATION_ALERT_VIEW_TAG                         9878


#pragma mark -
#pragma mark Game Functions

#define GAME_LAYER_GROUP_KEY                                    "GameLayerSelectors"


#pragma mark -
#pragma mark Game Center

#define LEADER_BOARD_CATEGORY_ID_KEY                             "leaderboarCategoryId"
#define LEADER_BOARD_SCORE_KEY                                   "leaderboardSore"

#define OBJ_C_FUNC_SHOW_GAME_CENTER_LEADERBOARD                  "ShowGameCenterLeaderBoard"
#define OBJ_C_FUNC_AUTHENTICATE_GAME_CENTER_PLAYER               "AuthenticateGameCenterPlayer"

#define OBJ_C_FUNC_SUBMIT_SCORE_GAME_CENTER                      "SubmitScore"

#define RESET_SWITCH_STATE_CHANGE_MESSAGE                        "Are you sure you want to reset game status? This will erase your score !"

#endif
