//
//  ADXGdprBase.m
//  ADXLibrary
//
//  Created by sunny on 2020. 9. 16..
//

#import "ADXGdprBase.h"

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
    #import <MoPubSDKFramework/MoPub.h>
#else
    #import "MoPub.h"
#endif

#import <AdSupport/AdSupport.h>

#define URL_LOC         @"http://adservice.google.com/getconfig/pubvendors"
#define URL_IN_EEA      @"?debug_geo=1"
#define URL_NOT_IN_EEA  @"?debug_geo=2"

#define CONSENT_STATE   @"consent_state"

@import GoogleMobileAds;

static UIWindow *currentWindow = nil;

@interface ADXGdprBase ()
@end

@implementation ADXGdprBase

+ (ADXGdprBase *)sharedInstance {
    static ADXGdprBase *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ADXGdprBase alloc] init];
    });
    
    return sharedInstance;
}

//*** ADX Consent 요청
- (void)showADXConsent:(ADXConsentCompletionBlock)completionBlock {
    
    //*** 현재 State 확인
    ADXConsentState consentState = [self getConsentState];
    
    if (self.debugState == ADXDebugLocateInEEA) {
        //*** location EEA 강제 설정
        if (consentState == ADXConsentStateUnknown) {
            [self showConsentController:^(ADXConsentState consentState, BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(consentState, success);
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(consentState, TRUE);
            });
        }
    } else if (self.debugState == ADXDebugLocateNotEEA) {
        //*** location NO EEA 강제 설정
        [self setConsentState:ADXConsentStateNotRequired];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(ADXConsentStateNotRequired, TRUE);
        });
        
    } else {
        //*** 기본 프로세스
        if (consentState == ADXConsentStateUnknown) {
            __weak ADXGdprBase *weakSelf = self;
            
            //*** 현재 위치 확인
            [self checkInEEAorUnknown:^(ADXLocate locate) {
                switch (locate) {
                    case ADXLocateNotEEA:
                    {
                        [weakSelf setConsentState:ADXConsentStateNotRequired];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(ADXConsentStateNotRequired, TRUE);
                        });
                    }
                        break;
                    case ADXLocateCheckFail:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(consentState, FALSE);
                        });
                    }
                        break;
                    case ADXLocateInEEAorUnknown:
                    {
                        [weakSelf showConsentController:^(ADXConsentState consentState, BOOL success) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completionBlock(consentState, success);
                            });
                        }];
                    }
                        break;
                    default:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(consentState, FALSE);
                        });
                    }
                        break;
                }
            }];
        } else {
            //*** 이미 state가 존재하는 사용자 (consent controller 미노출)
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(consentState, TRUE);
            });
        }
    }
}

//*** 동의 화면 보여주기
- (void)showConsentController:(ADXConsentCompletionBlock)completionBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *presentedWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        [presentedWindow setBackgroundColor:[UIColor whiteColor]];
        
        ADXConsentViewController *consentVc = [[ADXConsentViewController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:consentVc];
        [navigation setNavigationBarHidden:TRUE];
        
        presentedWindow.rootViewController      = navigation;
        presentedWindow.windowLevel             = UIWindowLevelAlert + 1;
        presentedWindow.hidden                  = NO;
        
        currentWindow = presentedWindow;
        
        __weak ADXGdprBase *weakSelf = self;
        
        ADXUserConfirmedBlock confirmedBlock = ^(BOOL success) {
            
            if (!completionBlock) {
                return;
            }
            currentWindow.hidden = YES;
            currentWindow = nil;
            
            ADXConsentState state = [weakSelf getConsentState];
            completionBlock(state, success);
        };
        
        [consentVc setConfirmedBlock:confirmedBlock];
        
    });
    
}


- (void)checkInEEAorUnknown:(ADXConsentInformationUpdateHandler)handler {
    
    [self requestCheckInEEAorUnknown:handler];
}


- (void)requestCheckInEEAorUnknown:(ADXConsentInformationUpdateHandler)handler {
    
    // Calls handler asynchronously.
    ADXConsentInformationUpdateHandler asyncHandler = ^(ADXLocate locate) {
        if (!handler) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(locate);
        });
    };
    
    NSURL *infoURL = [self getRequestURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:infoURL
                                            completionHandler:^(NSData *_Nullable data,
                                                                NSURLResponse *_Nullable response,
                                                                NSError *_Nullable error) {
                                                if (error || !data.length) {
                                                    if (!error) {
                                                        error = ErrorWithDescription(@"Invalid response.");
                                                    }
                                                    asyncHandler(ADXLocateCheckFail);
                                                    return;
                                                }
                                                
                                                NSDictionary<NSString *, id> *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                
                                                if (error || ![info isKindOfClass:[NSDictionary class]]) {
                                                    if (!error) {
                                                        error = ErrorWithDescription(@"Invalid response.");
                                                    }
                                                    asyncHandler(ADXLocateCheckFail);
                                                    return;
                                                }
                                                
                                                NSNumber *requestInEEAValue = info[@"is_request_in_eea_or_unknown"];
                                                BOOL isRequestInEEAOrUnknown = requestInEEAValue.boolValue;
                                                
                                                if (isRequestInEEAOrUnknown) {
                                                    asyncHandler(ADXLocateInEEAorUnknown);
                                                } else {
                                                    asyncHandler(ADXLocateNotEEA);
                                                }
                                            }];
    [dataTask resume];
}

- (NSURL *)getRequestURL {
    
    NSString *urlString = URL_LOC;
    
    switch (self.debugState) {
        case ADXDebugLocateInEEA:
            urlString = [urlString stringByAppendingString:URL_IN_EEA];
            break;
        case ADXDebugLocateNotEEA:
            urlString = [urlString stringByAppendingString:URL_NOT_IN_EEA];
            break;
        default:
            break;
    }
    
    return [NSURL URLWithString:urlString];
}

- (NSURL *)getPrivacyPolicyURL {
    return [NSURL URLWithString:@"https://assets.adxcorp.kr/privacy/partners"];
}

- (ADXConsentState)getConsentState {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ADXConsentState state = [defaults integerForKey:CONSENT_STATE];
    return state;
}

- (void)setConsentState:(ADXConsentState)state {
    
    ASIdentifierManager *adIdentManager = [ASIdentifierManager sharedManager];
    if (state == ADXConsentStateDenied && adIdentManager.advertisingTrackingEnabled == FALSE) {
        [[MoPub sharedInstance] revokeConsent];
    } else {
        [[MoPub sharedInstance] grantConsent];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:state forKey:CONSENT_STATE];
    [defaults synchronize];
}

NSError *_Nonnull ErrorWithDescription(NSString *_Nonnull description) {
    return [[NSError alloc] initWithDomain:@"ADXConsent"
                                      code:1
                                  userInfo:@{ NSLocalizedDescriptionKey : description ?: @"Internal error."}];
}

@end
