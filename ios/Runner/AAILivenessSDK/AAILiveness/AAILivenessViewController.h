//
//  AAILivenessWrapViewController.h
//  AAILivenessDemo
//
//  Created by Advance.ai on 2019/3/2.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAILivenessViewController : UIViewController
@property (copy, nonatomic, nullable) void (^result)(NSDictionary *);
@end

NS_ASSUME_NONNULL_END
