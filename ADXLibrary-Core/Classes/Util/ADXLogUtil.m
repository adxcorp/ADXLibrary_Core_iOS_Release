//
//  ADXLogUtil.m
//  ADXLibrary
//
//  Created by sunny on 2020/08/10.
//

#import "ADXLogUtil.h"
#import "ADXGdprBase.h"

@implementation ADXLogUtil

NSString *const kADXPlatformAdColony = @"AdColony";
NSString *const kADXPlatformAdFit = @"AdFit";
NSString *const kADXPlatformAdPie = @"AdPie";
NSString *const kADXPlatformCauly = @"Cauly";
NSString *const kADXPlatformFacebook = @"FAN";
NSString *const kADXPlatformAdMob = @"AdMob";
NSString *const kADXPlatformIronSource = @"ironSource";
NSString *const kADXPlatformMoPub = @"MoPub";
NSString *const kADXPlatformUnityAds = @"UnityAds";
NSString *const kADXPlatformVungle = @"Vungle";

NSString *const kADXInventroyBanner = @"Banner";
NSString *const kADXInventroyInterstitial = @"Interstitial";
NSString *const kADXInventroyNative = @"Native";
NSString *const kADXInventroyRewardedVideo = @"RewardedVideo";

NSString *const kADXEventLoad = @"Load";
NSString *const kADXEventLoadSuccess = @"Success";
NSString *const kADXEventLoadFailure = @"Failure";
NSString *const kADXEventImpression = @"Impression";
NSString *const kADXEventClick = @"Click";
NSString *const kADXEventReward = @"Reward";
NSString *const kADXEventClosed = @"Closed";

void ADXLogEvent(NSString *platform,
                 NSString *inventory,
                 NSString *event) {
    
    if ([ADXGdprBase sharedInstance].logEnable) {
        NSLog(@"AD(X)[%@|%@]: %@", platform, inventory, event);
    }
}

@end
