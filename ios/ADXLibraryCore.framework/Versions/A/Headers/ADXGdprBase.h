//
//  ADXGdprBase.h
//  ADXLibrary
//
//  Created by sunny on 2020. 9. 16..
//

#import <Foundation/Foundation.h>
#import "ADXConsentViewController.h"

#define ADX_CORE_SDK_VERSION @"1.0.2"

typedef NS_ENUM(NSInteger, ADXConsentState) {
    ADXConsentStateUnknown      = 0,
    ADXConsentStateNotRequired  = 1,
    ADXConsentStateDenied       = 2,
    ADXConsentStateConfirm      = 3,
};

typedef NS_ENUM(NSInteger, ADXLocate) {
    ADXLocateInEEAorUnknown     = 0,
    ADXLocateNotEEA             = 1,
    ADXLocateCheckFail          = 2,
};

typedef NS_ENUM(NSInteger, ADXDebugState) {
    ADXDebugLocateDefault       = 0,
    ADXDebugLocateInEEA         = 1,
    ADXDebugLocateNotEEA        = 2,
};

typedef void(^ADXConsentCompletionBlock)(ADXConsentState consentState, BOOL success);
typedef void (^ADXConsentInformationUpdateHandler)(ADXLocate locate);
typedef void(^ADXUserConfirmedBlock)(BOOL);

@interface ADXGdprBase : NSObject

@property (nonatomic, assign) ADXDebugState debugState;
@property (nonatomic) BOOL logEnable;

/**
 get instance

 @return ADXGdprBase instance
 */
+ (ADXGdprBase *)sharedInstance;

/**
 check and show consent

 @param completionBlock consentState, success
 */
- (void)showADXConsent:(ADXConsentCompletionBlock)completionBlock;

/**
 check locate

 @param handler comletion with ADXLocate
 */
- (void)checkInEEAorUnknown:(ADXConsentInformationUpdateHandler)handler;

/**
 read consent state

 @return ADXConsentState
 */
- (ADXConsentState)getConsentState;

/**
 change consent state

 @param state ADXConsentState
 */
- (void)setConsentState:(ADXConsentState)state;

/**
 get ADX privacy policy url

 @return URL
*/
- (NSURL *)getPrivacyPolicyURL;

@end
