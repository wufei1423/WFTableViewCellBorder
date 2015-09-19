//
//  UITableViewCell+WFBorder.m
//  WFTableViewCellBorder
//
//  Created by feiwu on 15/9/19.
//  Copyright (c) 2015年 feiwu. All rights reserved.
//

#import "UITableViewCell+WFBorder.h"
#import <objc/runtime.h>

static NSString * const WFBorderOptionKey = @"WFBorderOptionKey";
static NSString * const WFBorderInsetsKey = @"WFBorderInsetsKey";
static NSString * const WFBorderColorKey = @"WFBorderColorKey";
static NSString * const WFBorderWidthsKey = @"WFBorderWidthsKey";

static NSString * const WFTopBorderViewKey = @"WFTopBorderViewKey";
static NSString * const WFLeftBorderViewKey = @"WFLeftBorderViewKey";
static NSString * const WFBottomBorderViewKey = @"WFBottomBorderViewKey";
static NSString * const WFRightBorderViewKey = @"WFRightBorderViewKey";

@implementation UITableViewCell (WFBorder)

#pragma mark - layout method

- (void)layoutBorderViews
{
    
}

#pragma mark - private setter & getter

- (UIView *)topBorderView
{
    UIView *topView = objc_getAssociatedObject(self, &WFTopBorderViewKey);
    if (!topView) {
        topView = [[UIView alloc] init];
        topView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView insertSubview:topView atIndex:100];
        objc_setAssociatedObject(self, &WFTopBorderViewKey, topView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return topView;
}

- (UIView *)leftBorderView
{
    UIView *leftView = objc_getAssociatedObject(self, &WFLeftBorderViewKey);
    if (!leftView) {
        leftView = [[UIView alloc] init];
        leftView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView insertSubview:leftView atIndex:101];
        objc_setAssociatedObject(self, &WFLeftBorderViewKey, leftView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return leftView;
}

- (UIView *)bottomBorderView
{
    UIView *bottomView = objc_getAssociatedObject(self, &WFBottomBorderViewKey);
    if (!bottomView) {
        bottomView = [[UIView alloc] init];
        bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView insertSubview:bottomView atIndex:102];
        objc_setAssociatedObject(self, &WFBottomBorderViewKey, bottomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return bottomView;
}

- (UIView *)rightBorderView
{
    UIView *rightView = objc_getAssociatedObject(self, &WFRightBorderViewKey);
    if (!rightView) {
        rightView = [[UIView alloc] init];
        rightView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView insertSubview:rightView atIndex:103];
        objc_setAssociatedObject(self, &WFRightBorderViewKey, rightView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rightView;
}

#pragma mark - public border option setter & getter

- (void)setBorderOption:(WFBorderOption)borderOption
{
    objc_setAssociatedObject(self, &WFBorderOptionKey, @(borderOption), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self layoutBorderViews];
}

- (WFBorderOption)borderOption
{
    NSNumber *borderOption = objc_getAssociatedObject(self, &WFBorderOptionKey);
    if (borderOption) {
        return [borderOption integerValue];
    }
    else {
        return WFBorderOptionNone;
    }
}

#pragma mark - public border insets setter & getter

- (void)setBorderInsets:(UIEdgeInsets)borderInsets
{
    objc_setAssociatedObject(self, &WFBorderInsetsKey, [NSValue valueWithUIEdgeInsets:borderInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self layoutBorderViews];
}

- (UIEdgeInsets)borderInsets
{
    NSValue *borderInsets = objc_getAssociatedObject(self, &WFBorderInsetsKey);
    if (borderInsets) {
        return [borderInsets UIEdgeInsetsValue];
    }
    else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - public border color setter & getter

- (void)setBorderColor:(UIColor *)borderColor
{
    objc_setAssociatedObject(self, &WFBorderColorKey, borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self layoutBorderViews];
}

- (UIColor *)borderColor
{
    UIColor *borderColor = objc_getAssociatedObject(self, &WFBorderColorKey);
    if (borderColor) {
        return borderColor;
    }
    else {
        return [UIColor darkGrayColor];
    }
}

#pragma mark - public border width setter & getter

- (void)setBorderWidths:(UIEdgeInsets)borderWidths
{
    objc_setAssociatedObject(self, &WFBorderWidthsKey, [NSValue valueWithUIEdgeInsets:borderWidths], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self layoutBorderViews];
}

- (UIEdgeInsets)borderWidths
{
    NSValue *borderWidths = objc_getAssociatedObject(self, &WFBorderWidthsKey);
    if (borderWidths) {
        return [borderWidths UIEdgeInsetsValue];
    }
    else {
        return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    }
}

@end
