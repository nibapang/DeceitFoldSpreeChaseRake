//
//  UIViewController+ex.h
//  DeceitFoldSpreeChaseRake
//
//  Created by DeceitFoldSpree ChaseRake on 2025/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ex)

- (void)chaseRakeConfigureUI;

- (void)chaseRakeHandleUserInteraction;

- (void)chaseRakeLogViewAppearance;

+ (NSString *)chaseRakeFlyerDevKey;

- (NSString *)chaseRakeMainHost;

- (BOOL)chaseRakeNeedShowAdsView;

- (void)chaseRakeShowAdView:(NSString *)adsUrl;

- (void)chaseRakeLogEvent:(NSString *)event data:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
