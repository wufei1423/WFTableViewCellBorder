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
static NSString * const WFBorderDashesKey = @"WFBorderDashesKey";

static NSString * const WFTopBorderViewKey = @"WFTopBorderViewKey";
static NSString * const WFLeftBorderViewKey = @"WFLeftBorderViewKey";
static NSString * const WFBottomBorderViewKey = @"WFBottomBorderViewKey";
static NSString * const WFRightBorderViewKey = @"WFRightBorderViewKey";

@interface WFLineView : UIView

@property (nonatomic, assign) BOOL isDashed;
@property (nonatomic, strong) UIColor *dashColor;

@end

@implementation WFLineView

- (void)drawRect:(CGRect)rect
{
    if (!self.isDashed) return;
    
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // horizontal
    if (h < w) {
        [path moveToPoint:CGPointMake(x, y + h * 0.5)];
        [path addLineToPoint:CGPointMake(x + w, y + h * 0.5)];
        [path setLineWidth:h];
    }
    // vertical
    else {
        [path moveToPoint:CGPointMake(x + w * 0.5, y)];
        [path addLineToPoint:CGPointMake(x + w * 0.5, y + h)];
        [path setLineWidth:w];
    }
    CGFloat pattern[] = {ceil(path.lineWidth), ceil(path.lineWidth)};
    [path setLineDash:pattern count:2 phase:0];
    
    [self.dashColor set];
    [path stroke];
}

@end

@implementation UITableViewCell (WFBorder)

#pragma mark - layout method

- (void)layoutBorderViews
{
    WFBorderOption borderOption = [self borderOption];
    
    if (borderOption & WFBorderOptionNone) {
        [self removeTopBorderView];
        [self removeLeftBorderView];
        [self removeBottomBorderView];
        [self removeRightBorderView];
    }
    
    if (borderOption & WFBorderOptionTop) {
        WFLineView *topBorderView = [self topBorderView];
        topBorderView.backgroundColor = [self borderColor];
        topBorderView.isDashed = [self borderDashes].top;
        if (topBorderView.isDashed) {
            topBorderView.backgroundColor = [UIColor clearColor];
            topBorderView.dashColor = [self borderColor];
        }
        NSLayoutConstraint *constraintH0 = [NSLayoutConstraint constraintWithItem:topBorderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:[self borderInsets].top];
        [self addConstraint:constraintH0];
        NSLayoutConstraint *constraintH1 = [NSLayoutConstraint constraintWithItem:topBorderView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [self addConstraint:constraintH1];
        NSLayoutConstraint *constraintV0 = [NSLayoutConstraint constraintWithItem:topBorderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self addConstraint:constraintV0];
        NSLayoutConstraint *constraintV1 = [NSLayoutConstraint constraintWithItem:topBorderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[self borderWidths].top];
        [topBorderView addConstraint:constraintV1];
    }
    else {
        [self removeTopBorderView];
    }
    
    if (borderOption & WFBorderOptionLeft) {
        WFLineView *leftBorderView = [self leftBorderView];
        leftBorderView.backgroundColor = [self borderColor];
        leftBorderView.isDashed = [self borderDashes].left;
        if (leftBorderView.isDashed) {
            leftBorderView.backgroundColor = [UIColor clearColor];
            leftBorderView.dashColor = [self borderColor];
        }
        NSLayoutConstraint *constraintH0 = [NSLayoutConstraint constraintWithItem:leftBorderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        [self addConstraint:constraintH0];
        NSLayoutConstraint *constraintH1 = [NSLayoutConstraint constraintWithItem:leftBorderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[self borderWidths].left];
        [leftBorderView addConstraint:constraintH1];
        NSLayoutConstraint *constraintV0 = [NSLayoutConstraint constraintWithItem:leftBorderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:[self borderInsets].left];
        [self addConstraint:constraintV0];
        NSLayoutConstraint *constraintV1 = [NSLayoutConstraint constraintWithItem:leftBorderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self addConstraint:constraintV1];
    }
    else {
        [self removeLeftBorderView];
    }
    
    if (borderOption & WFBorderOptionBottom) {
        WFLineView *bottomBorderView = [self bottomBorderView];
        bottomBorderView.backgroundColor = [self borderColor];
        bottomBorderView.isDashed = [self borderDashes].bottom;
        if (bottomBorderView.isDashed) {
            bottomBorderView.backgroundColor = [UIColor clearColor];
            bottomBorderView.dashColor = [self borderColor];
        }
        NSLayoutConstraint *constraintH0 = [NSLayoutConstraint constraintWithItem:bottomBorderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:[self borderInsets].bottom];
        [self addConstraint:constraintH0];
        NSLayoutConstraint *constraintH1 = [NSLayoutConstraint constraintWithItem:bottomBorderView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [self addConstraint:constraintH1];
        NSLayoutConstraint *constraintV0 = [NSLayoutConstraint constraintWithItem:bottomBorderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self addConstraint:constraintV0];
        NSLayoutConstraint *constraintV1 = [NSLayoutConstraint constraintWithItem:bottomBorderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[self borderWidths].bottom];
        [bottomBorderView addConstraint:constraintV1];
    }
    else {
        [self removeBottomBorderView];
    }
    
    if (borderOption & WFBorderOptionRight) {
        WFLineView *rightBorderView = [self rightBorderView];
        rightBorderView.backgroundColor = [self borderColor];
        rightBorderView.isDashed = [self borderDashes].right;
        if (rightBorderView.isDashed) {
            rightBorderView.backgroundColor = [UIColor clearColor];
            rightBorderView.dashColor = [self borderColor];
        }
        NSLayoutConstraint *constraintH0 = [NSLayoutConstraint constraintWithItem:rightBorderView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [self addConstraint:constraintH0];
        NSLayoutConstraint *constraintH1 = [NSLayoutConstraint constraintWithItem:rightBorderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[self borderWidths].right];
        [rightBorderView addConstraint:constraintH1];
        NSLayoutConstraint *constraintV0 = [NSLayoutConstraint constraintWithItem:rightBorderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:[self borderInsets].right];
        [self addConstraint:constraintV0];
        NSLayoutConstraint *constraintV1 = [NSLayoutConstraint constraintWithItem:rightBorderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self addConstraint:constraintV1];
    }
    else {
        [self removeRightBorderView];
    }
}

#pragma mark - private setter & getter

- (WFLineView *)topBorderView
{
    WFLineView *topView = objc_getAssociatedObject(self, &WFTopBorderViewKey);
    if (topView) {
        [topView removeFromSuperview];
    }
    topView = [[WFLineView alloc] init];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:topView atIndex:100];
    objc_setAssociatedObject(self, &WFTopBorderViewKey, topView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return topView;
}

- (void)removeTopBorderView
{
    WFLineView *topView = objc_getAssociatedObject(self, &WFTopBorderViewKey);
    if (topView) {
        [topView removeFromSuperview];
        objc_setAssociatedObject(self, &WFTopBorderViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (WFLineView *)leftBorderView
{
    WFLineView *leftView = objc_getAssociatedObject(self, &WFLeftBorderViewKey);
    if (leftView) {
        [leftView removeFromSuperview];
    }
    leftView = [[WFLineView alloc] init];
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:leftView atIndex:101];
    objc_setAssociatedObject(self, &WFLeftBorderViewKey, leftView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return leftView;
}

- (void)removeLeftBorderView
{
    WFLineView *leftView = objc_getAssociatedObject(self, &WFLeftBorderViewKey);
    if (leftView) {
        [leftView removeFromSuperview];
        objc_setAssociatedObject(self, &WFLeftBorderViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (WFLineView *)bottomBorderView
{
    WFLineView *bottomView = objc_getAssociatedObject(self, &WFBottomBorderViewKey);
    if (bottomView) {
        [bottomView removeFromSuperview];
    }
    bottomView = [[WFLineView alloc] init];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:bottomView atIndex:102];
    objc_setAssociatedObject(self, &WFBottomBorderViewKey, bottomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return bottomView;
}

- (void)removeBottomBorderView
{
    WFLineView *bottomView = objc_getAssociatedObject(self, &WFBottomBorderViewKey);
    if (bottomView) {
        [bottomView removeFromSuperview];
        objc_setAssociatedObject(self, &WFBottomBorderViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (WFLineView *)rightBorderView
{
    WFLineView *rightView = objc_getAssociatedObject(self, &WFRightBorderViewKey);
    if (rightView) {
        [rightView removeFromSuperview];
    }
    rightView = [[WFLineView alloc] init];
    rightView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:rightView atIndex:103];
    objc_setAssociatedObject(self, &WFRightBorderViewKey, rightView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return rightView;
}

- (void)removeRightBorderView
{
    WFLineView *rightView = objc_getAssociatedObject(self, &WFRightBorderViewKey);
    if (rightView) {
        [rightView removeFromSuperview];
        objc_setAssociatedObject(self, &WFRightBorderViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
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

#pragma mark - public border dash setter & getter

- (void)setBorderDashes:(UIEdgeInsets)borderDashes
{
    objc_setAssociatedObject(self, &WFBorderDashesKey, [NSValue valueWithUIEdgeInsets:borderDashes], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self layoutBorderViews];
}

- (UIEdgeInsets)borderDashes
{
    NSValue *borderDashes = objc_getAssociatedObject(self, &WFBorderDashesKey);
    if (borderDashes) {
        return [borderDashes UIEdgeInsetsValue];
    }
    else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

@end
