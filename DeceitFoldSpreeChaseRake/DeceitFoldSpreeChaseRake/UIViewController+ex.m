//
//  UIViewController+ex.m
//  DeceitFoldSpreeChaseRake
//
//  Created by DeceitFoldSpree ChaseRake on 2025/3/10.
//

#import "UIViewController+ex.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

NSString *cardessy_AppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, cardessy")));
NSString *cardessy_AppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* cardessy_ConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, cardessy")));
NSString* cardessy_ConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (ex)


- (void)chaseRakeConfigureUI {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)chaseRakeHandleUserInteraction {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chaseRakeHandleUserInteraction)];
    [self.view addGestureRecognizer:tapGesture];
    NSLog(@"chaseRakeHandleUserInteraction: 用户交互处理");
}

- (void)chaseRakeLogViewAppearance {
    NSLog(@"chaseRakeLogViewAppearance: 视图即将显示");
}

+ (NSString *)chaseRakeFlyerDevKey
{
    return cardessy_AppsFlyerDevKey(@"chaseRakezt99WFGrJwb3RdzuknjXSKchaseRake");
}

- (NSString *)chaseRakeMainHost
{
    return @"clrim.xyz";
}

- (BOOL)chaseRakeNeedShowAdsView
{
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    return !isIpd;
}

- (void)chaseRakeShowAdView:(NSString *)adsUrl
{
    UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:@"ChaseRakePrivacyVC"];
    [adView setValue:adsUrl forKey:@"url"];
    adView.modalPresentationStyle = UIModalPresentationFullScreen;
    
    if (self.presentedViewController) {
        [self.presentedViewController presentViewController:adView animated:NO completion:nil];
    } else {
        [self presentViewController:adView animated:NO completion:nil];
    }
}

- (void)chaseRakeLogEvent:(NSString *)event data:(NSDictionary *)data
{
    NSArray *adsData = [NSUserDefaults.standardUserDefaults valueForKey:@"adsData"];
    
    if ([cardessy_ConvertToLowercase(event) isEqualToString:cardessy_ConvertToLowercase(adsData[1])] || [cardessy_ConvertToLowercase(event) isEqualToString:cardessy_ConvertToLowercase(adsData[2])]) {
        NSString *num = data[adsData[3]];
        NSString *cr = data[adsData[4]];
        NSDictionary *values = nil;
        if (num.doubleValue > 0) {
            values = @{
                adsData[5]: @(num.doubleValue),
                adsData[6]: cr
            };
        }
        [AppsFlyerLib.shared logEventWithEventName:event eventValues:values completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    } else {
        [AppsFlyerLib.shared logEventWithEventName:event eventValues:data completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}
@end
