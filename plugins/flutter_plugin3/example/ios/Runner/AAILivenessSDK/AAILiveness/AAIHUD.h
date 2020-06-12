//
//  AAIHUD.h
//  UIDemo
//
//  Created by Advance.ai on 2019/3/8.
//  Copyright © 2019 Liveness.AI.Advance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAIHUDHandlerItem : NSObject
@property(nonatomic, copy) NSString *btnTitle;
@property(nonatomic, copy) void (^handler)(void);
@end

@interface AAIHUD : UIView

+ (void)showWaitWithMsg:(NSString *)msg onView:(UIView *)sv;
+ (void)showMsg:(NSString *)msg onView:(UIView *)sv;
+ (void)showMsg:(NSString *)msg onView:(UIView *)sv duration:(NSTimeInterval)interval;
+ (void)dismissHUDOnView:(UIView *)sv afterDelay:(NSTimeInterval)interval;

+ (void)showAlertWithMsg:(NSString *)msg onView:(UIView *)sv handlerItem:(AAIHUDHandlerItem *)handlerItem;

@end

NS_ASSUME_NONNULL_END
