//
//  AAIHUD.m
//  UIDemo
//
//  Created by Advance.ai on 2019/3/8.
//  Copyright © 2019 Liveness.AI.Advance. All rights reserved.
//

#import "AAIHUD.h"

@implementation AAIHUDHandlerItem
@end

@interface AAIHUD()
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property(nonatomic, strong) UILabel *msgLabel;
@property(nonatomic, strong) AAIHUDHandlerItem *handlerItem;
@property(nonatomic, strong) UIButton *handlerButton;
@end

@implementation AAIHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *sv = self;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [sv addSubview:indicatorView];
        _indicatorView = indicatorView;

        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [sv addSubview:label];
        _msgLabel = label;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self sizeThatFits:[UIScreen mainScreen].bounds.size];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat imgWidth = 37, marginLeft = 14, marginTop = 18, padding = 8, minWidth = 120;
    _msgLabel.preferredMaxLayoutWidth = size.width - 2 * marginLeft - padding;
    CGSize labelSize = [_msgLabel sizeThatFits:CGSizeMake(_msgLabel.preferredMaxLayoutWidth, size.height)];
    
    CGFloat width = labelSize.width + 2 * marginLeft;
    if (width < _msgLabel.preferredMaxLayoutWidth) {
        if (width < (imgWidth + 2 * marginLeft)) {
            width = imgWidth + 2 * marginLeft;
        }
    }
    if (width < minWidth) {
        width = minWidth;
    }
    
    CGFloat height = marginTop;
    CGFloat top = 0;
    if (_indicatorView.hidden == NO) {
        _indicatorView.frame = CGRectMake((width - imgWidth)/2, marginTop, imgWidth, imgWidth);
        height += imgWidth;
        if (_msgLabel.hidden == NO) {
            height += padding;
        }
        top = CGRectGetMaxY(_indicatorView.frame);
    } else {
        top = marginTop;
    }
    
    if (_msgLabel.hidden == NO) {
        if (_indicatorView.hidden == NO) {
            top += padding;
        }
        _msgLabel.frame = CGRectMake((width - labelSize.width)/2, top, labelSize.width, labelSize.height);
        height += labelSize.height;
    }
    
    if (_handlerItem) {
        if (_handlerButton.superview == nil) {
            [self addSubview:_handlerButton];
        }
        
        [_handlerButton.titleLabel sizeToFit];
        CGSize btnSize = _handlerButton.titleLabel.bounds.size;
        btnSize.width += 20;
        btnSize.height += 20;
        
        if (width <= btnSize.width) {
            width = btnSize.width + 2 * marginLeft;
            CGPoint originCenter = _msgLabel.center;
            originCenter.x = width/2;
            _msgLabel.center = originCenter;
            _handlerButton.frame = CGRectMake(marginLeft, height + padding, btnSize.width, btnSize.height);
        } else {
            _handlerButton.frame = CGRectMake(marginLeft, height + padding, width - 2 * marginLeft, btnSize.height);
        }
        height += (padding + btnSize.height);
    }
    
    height += marginTop;
    if (height > size.height) {
        height = size.height;
    }
    
    return CGSizeMake(width, height);
}

+ (void)showWaitWithMsg:(NSString *)msg onView:(UIView *)sv
{
    [self dismissHUDOnView:sv];
    
    AAIHUD *hud = [self createHUDIfNeeded:sv];
    hud.handlerItem = nil;
    if (hud.handlerButton) {
        hud.handlerButton.hidden = YES;
    }
    
    hud.indicatorView.hidden = NO;
    [hud.indicatorView startAnimating];
    hud.msgLabel.text = msg;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize size = [hud sizeThatFits:screenSize];
    hud.bounds = CGRectMake(0, 0, size.width, size.height);
    hud.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    
    hud.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        hud.alpha = 1;
    }];
}

+ (void)showAlertWithMsg:(NSString *)msg onView:(UIView *)sv handlerItem:(AAIHUDHandlerItem *)handlerItem
{
    [self dismissHUDOnView:sv];
    
    AAIHUD *hud = [self createHUDIfNeeded:sv];
    hud.msgLabel.text = msg;
    hud.indicatorView.hidden = YES;
    hud.handlerItem = handlerItem;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:handlerItem.btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    btn.layer.cornerRadius = 4;
    [btn addTarget:hud action:@selector(tapBtnAction) forControlEvents:UIControlEventTouchUpInside];
    hud.handlerButton = btn;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize size = [hud sizeThatFits:screenSize];
    hud.bounds = CGRectMake(0, 0, size.width, size.height);
    hud.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    
    hud.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        hud.alpha = 1;
    }];
}

- (void)tapBtnAction
{
    if (self.handlerItem.handler) {
        self.handlerItem.handler();
        [[self class] dismissHUDOnView:self.superview afterDelay:0];
    }
}

+ (AAIHUD *)hudForView:(UIView *)sv
{
    NSEnumerator *subviewsEnum = [sv.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            AAIHUD *hud = (AAIHUD *)subview;
            return hud;
        }
    }
    return nil;
}

+ (AAIHUD *)createHUDIfNeeded:(UIView *)sv
{
    AAIHUD *hud = [self hudForView:sv];
    if (!hud) {
        hud = [[AAIHUD alloc] initWithFrame:CGRectZero];
        hud.backgroundColor =  [UIColor colorWithRed:(0x20/255.f) green:(0x20/255.f) blue:(0x20/255.f) alpha:0.86];
        [sv addSubview:hud];
    }
    hud.layer.cornerRadius = 4;
    return hud;
}

+ (void)showMsg:(NSString *)msg onView:(UIView *)sv
{
    [self dismissHUDOnView:sv];
    
    AAIHUD *hud = [self createHUDIfNeeded:sv];
    hud.msgLabel.text = msg;
    hud.indicatorView.hidden = YES;
    hud.handlerItem = nil;
    if (hud.handlerButton) {
        hud.handlerButton.hidden = YES;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize size = [hud sizeThatFits:screenSize];
    hud.bounds = CGRectMake(0, 0, size.width, size.height);
    hud.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    
    hud.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        hud.alpha = 1;
    }];
}

+ (void)showMsg:(NSString *)msg onView:(UIView *)sv duration:(NSTimeInterval)interval
{
    [self showMsg:msg onView:sv];
    [self dismissHUDOnView:sv afterDelay:interval];
}

+ (void)dismissHUDOnView:(UIView *)sv
{
    AAIHUD *hud = [self hudForView:sv];
    if (hud) {
        [hud removeFromSuperview];
    }
}

+ (void)dismissHUDOnView:(UIView *)sv afterDelay:(NSTimeInterval)interval
{
    AAIHUD *hud = [self hudForView:sv];
    if (!hud) {
        return;
    }
    
    [UIView animateWithDuration:0.3 delay:interval options:UIViewAnimationOptionCurveEaseInOut animations:^{
        hud.alpha = 0;
    } completion:^(BOOL finished) {
        [hud removeFromSuperview];
    }];
}

@end
