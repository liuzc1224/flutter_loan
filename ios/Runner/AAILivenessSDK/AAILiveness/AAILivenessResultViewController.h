//
//  AAILivenessResultViewController.h
//  AAILivenessDemo
//
//  Created by Advance.ai on 2019/2/25.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAILivenessResultViewController : UIViewController

///If stateKey not exist in AAILanguageString.bundle, resultLabel or stateLabel's content will be stateKey.
- (instancetype)initWithResult:(BOOL)succeed resultState:(NSString * _Nullable)stateKey;

- (instancetype)initWithResultInfo:(NSDictionary *)resultInfo;

@end

NS_ASSUME_NONNULL_END
