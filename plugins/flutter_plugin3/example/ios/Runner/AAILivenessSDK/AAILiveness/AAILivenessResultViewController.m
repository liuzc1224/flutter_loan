//
//  AAILivenessResultViewController.m
//  AAILivenessDemo
//
//  Created by Advance.ai on 2019/2/25.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import "AAILivenessResultViewController.h"
#import <AAILivenessSDK/AAILivenessSDK.h>
#import "AAILivenessUtil.h"

@interface AAILivenessResultViewController ()
{
    BOOL _succeed;
    NSString *_stateKey;
    
    UIImageView *_stateImgView;
    UILabel *_resultLabel;
    UILabel *_stateLabel;
    
    UILabel *_scoreLabel;
    CGFloat _score;
    
    UIButton *_tryAgainBtn;
    UIButton *_backBtn;
}
@end

@implementation AAILivenessResultViewController

- (instancetype)initWithResultInfo:(NSDictionary *)resultInfo
{
    self = [super init];
    if (self) {
        _score = -1;
        
        NSError *error = resultInfo[@"error"];
        if (error == nil) {
            _succeed = YES;
            if (resultInfo[@"score"]) {
                _score = [resultInfo[@"score"] floatValue];
            }
        } else {
            _succeed = NO;
            _stateKey = error.localizedDescription;
        }
    }
    return self;
}

- (instancetype)initWithResult:(BOOL)succeed resultState:(NSString * _Nullable)stateKey
{
    self = [super init];
    if (self) {
        _score = -1;
        _succeed = succeed;
        _stateKey = stateKey;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *sv = self.view;
    sv.backgroundColor = [UIColor whiteColor];
    
    //Back button
    UINavigationController *navc = self.navigationController;
    if (navc == nil || (navc != nil && navc.navigationBarHidden)) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[AAILivenessUtil imgWithName:@"arrow_back"] forState:UIControlStateNormal];
        [sv addSubview:backBtn];
        [backBtn addTarget:self action:@selector(tapBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backBtn;
    }
    
    NSString *imgName = nil;
    NSString *stateStr = nil;
    if (_succeed) {
        imgName = @"icon_liveness_success@2x.jpg";
        stateStr = @"detection_success";
    } else {
        imgName = @"icon_liveness_fail@2x.jpg";
        stateStr = _stateKey ? _stateKey : @"detection_fail";
    }
    
    _stateImgView = [[UIImageView alloc] initWithImage:[AAILivenessUtil imgWithName:imgName]];
    [sv addSubview:_stateImgView];
    
    //
    _resultLabel = [[UILabel alloc] init];
    _resultLabel.font = [self pingfangFontWithSize:18];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    NSString *resultStrKey = _succeed ? @"detection_success" : @"detection_fail";
    _resultLabel.text = [AAILivenessUtil localStrForKey:resultStrKey];
    _resultLabel.numberOfLines = 0;
    [sv addSubview:_resultLabel];
    
    //
    if (!_succeed) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [self pingfangFontWithSize:15];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.numberOfLines = 0;
        NSString *localeStr = [AAILivenessUtil localStrForKey:stateStr];
        _stateLabel.text = localeStr ? localeStr : stateStr;
        _stateLabel.textColor = [UIColor colorWithRed:(0x55/255.f) green:(0x55/255.f) blue:(0x55/255.f) alpha:1];
        [sv addSubview:_stateLabel];
    }
    
    if (_score >= 0) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.font = [self pingfangFontWithSize:16];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.textColor = [UIColor colorWithRed:(0x55/255.f) green:(0x55/255.f) blue:(0x55/255.f) alpha:1];
        _scoreLabel.text = [NSString stringWithFormat:@"Liveness score: %.f",_score];
        [sv addSubview:_scoreLabel];
    }
    
    if (!_succeed) {
        _tryAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tryAgainBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_tryAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tryAgainBtn setTitle:[AAILivenessUtil localStrForKey:@"try_again"] forState:UIControlStateNormal];
        UIColor *bcgColor = [UIColor colorWithRed:(0x5C/255.f) green:(0xC4/255.f) blue:(0x14/255.f) alpha:1];
        UIImage *bcgImg = [self imageWithColor:bcgColor size:CGSizeMake(80, 44)];
        bcgImg = [bcgImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        [_tryAgainBtn setBackgroundImage:bcgImg forState:UIControlStateNormal];
        [_tryAgainBtn addTarget:self action:@selector(tapTryBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [sv addSubview:_tryAgainBtn];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //Config back button frame.
    CGFloat top = 0, marginLeft = 20, marginTop = 20;
    if (@available(iOS 11, *)) {
        top = self.view.safeAreaInsets.top;
    } else {
        if (self.navigationController.navigationBarHidden) {
            top = [UIApplication sharedApplication].statusBarFrame.size.height;
        } else {
            top = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
    
    if (_backBtn) {
        _backBtn.frame = CGRectMake(20, top + marginTop, 40, 40);
    }
    
    CGSize size = self.view.frame.size;
    CGSize imgSize = _stateImgView.bounds.size;
    _stateImgView.center = CGPointMake((size.width)/2, (size.height - imgSize.height)/2 - 40);
    
    CGSize preferMaxSize = CGSizeMake(size.width - 2 * marginLeft, size.height);
    CGSize lableSize = [_resultLabel sizeThatFits:preferMaxSize];
    _resultLabel.bounds = CGRectMake(0, 0, lableSize.width, lableSize.height);
    _resultLabel.center = CGPointMake(_stateImgView.center.x, CGRectGetMaxY(_stateImgView.frame) + 30);
    
    if (_stateLabel) {
        lableSize = [_stateLabel sizeThatFits:preferMaxSize];
        _stateLabel.bounds = CGRectMake(0, 0, lableSize.width, lableSize.height);
        _stateLabel.center = CGPointMake(_stateImgView.center.x, CGRectGetMaxY(_resultLabel.frame) + 45);
    }
    
    CGRect preViewFrame = _stateLabel.frame;
    if (_scoreLabel) {
        [_scoreLabel sizeToFit];
        _scoreLabel.center = CGPointMake(_resultLabel.center.x, _resultLabel.center.y + 40);
        preViewFrame = _scoreLabel.frame;
    }
    
    if (_tryAgainBtn) {
        CGFloat marginLeft = 40;
        _tryAgainBtn.frame = CGRectMake(marginLeft, CGRectGetMaxY(preViewFrame)+40, (size.width-2*marginLeft), 44);
    }
}

- (UIFont *)pingfangFontWithSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)tapBackBtnAction
{
    //You can customize the back logic.
    UINavigationController *navc = self.navigationController;
    if (navc && [navc.viewControllers containsObject:self]) {
        NSInteger count = navc.viewControllers.count;
        if (count >= 3) {
            //Skip the `AAILivenessViewController` page.
            [navc popToViewController:navc.viewControllers[count - 3] animated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)tapTryBtnAction
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kAAIRestart" object:nil];
    });
    [self.navigationController popViewControllerAnimated:YES];
}

@end
