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

static NSString * const WFTopBorderViewHorizontalConstraintsKey = @"WFTopBorderViewHorizontalConstraintsKey";
static NSString * const WFTopBorderViewVerticalConstraintsKey = @"WFTopBorderViewVerticalConstraintsKey";
static NSString * const WFLeftBorderViewHorizontalConstraintsKey = @"WFLeftBorderViewHorizontalConstraintsKey";
static NSString * const WFLeftBorderViewVerticalConstraintsKey = @"WFLeftBorderViewVerticalConstraintsKey";
static NSString * const WFBottomBorderViewHorizontalConstraintsKey = @"WFBottomBorderViewHorizontalConstraintsKey";
static NSString * const WFBottomBorderViewVerticalConstraintsKey = @"WFBottomBorderViewVerticalConstraintsKey";
static NSString * const WFRightBorderViewHorizontalConstraintsKey = @"WFRightBorderViewHorizontalConstraintsKey";
static NSString * const WFRightBorderViewVerticalConstraintsKey = @"WFRightBorderViewVerticalConstraintsKey";

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
    WFLineView *topBorderView = [self topBorderView];
    WFLineView *leftBorderView = [self leftBorderView];
    WFLineView *bottomBorderView = [self bottomBorderView];
    WFLineView *rightBorderView = [self rightBorderView];
    
    WFBorderOption borderOption = [self borderOption];
    
    if (borderOption & WFBorderOptionNone) {
        topBorderView.hidden = YES;
        leftBorderView.hidden = YES;
        bottomBorderView.hidden = YES;
        rightBorderView.hidden = YES;
    }
    
    if (borderOption & WFBorderOptionTop) {
        topBorderView.hidden = NO;
        topBorderView.backgroundColor = [self borderColor];
        topBorderView.isDashed = [self borderDashes].top;
        if (topBorderView.isDashed) {
            topBorderView.backgroundColor = [UIColor clearColor];
            topBorderView.dashColor = [self borderColor];
        }
        [self removeConstraints:objc_getAssociatedObject(self, &WFTopBorderViewHorizontalConstraintsKey)];
        [self removeConstraints:objc_getAssociatedObject(self, &WFTopBorderViewVerticalConstraintsKey)];
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[topBorderView]-0-|" options:0 metrics:@{@"margin": @([self borderInsets].top)} views:@{@"topBorderView": topBorderView}];
        objc_setAssociatedObject(self, &WFTopBorderViewHorizontalConstraintsKey, horizontalConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addConstraints:horizontalConstraints];
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topBorderView(height)]" options:0 metrics:@{@"height": @([self borderWidths].top)} views:@{@"topBorderView": topBorderView}];
        objc_setAssociatedObject(self, &WFTopBorderViewVerticalConstraintsKey, verticalConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addConstraints:verticalConstraints];
    }
    else {
        topBorderView.hidden = YES;
    }
    
    if (borderOption & WFBorderOptionLeft) {
        leftBorderView.hidden = NO;
        leftBorderView.backgroundColor = [self borderColor];
        leftBorderView.isDashed = [self borderDashes].left;
        if (leftBorderView.isDashed) {
            leftBorderView.backgroundColor = [UIColor clearColor];
            leftBorderView.dashColor = [self borderColor];
        }
        [self removeConstraints:objc_getAssociatedObject(self, &WFLeftBorderViewHorizontalConstraintsKey)];
        [self removeConstraints:objc_getAssociatedObject(self, &WFLeftBorderViewVerticalConstraintsKey)];
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[leftBorderView(width)]" options:0 metrics:@{@"width": @([self borderWidths].left)} views:@{@"leftBorderView": leftBorderView}];
        objc_setAssociatedObject(self, &WFLeftBorderViewHorizontalConstraintsKey, horizontalConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addConstraints:horizontalConstraints];
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[leftBorderView]-0-|" options:0 metrics:@{@"margin": @([self borderInsets].left)} views:@{@"leftBorderView": leftBorderView}];
        objc_setAssociatedObject(self, &WFLeftBorderViewVerticalConstraintsKey, verticalConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addConstraints:verticalConstraints];
    }
    else {
        leftBorderView.hidden = YES;
    }
    
    if (borderOption & WFBorderOptionBottom) {
        bottomBorderView.hidden = NO;
        bottomBorderView.backgroundColor = [self borderColor];
        bottomBorderView.isDashed = [self borderDashes].bottom;
        if (bottomBorderView.isDashed) {
            bottomBorderView.backgroundColor = [UIColor clearColor];
            bottomBorderView.dashColor = [self borderColor];
        }
        [self removeConstraints:objc_getAssociatedObject(self, &WFBottomBorderViewHorizontalConstraintsKey)];
        [self removeConstraints:objc_getAssociatedObject(self, &WFBottomBorderViewVerticalConstraintsKey)];
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[bottomBorderView]-0-|" options:0 metrics:@{@"margin": @([self borderInsets].bottom)} views:@{@"bottomBorderView": bottomBorderView}];
        objc_setAssociatedObject(self, &WFBottomBorderViewHorizontalConstraintsKey, horizontalConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addConstraints:horizontalConstraints];
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomBorderView(height)]-0-|" options:0 metrics:@{@"height": @([self borderWidths].bottom)} views:@{@"bottomBorderView": bottomBorderView}];
        objc_setAssociatedObject(self, &WFBottomBorderViewVerticalConstraintsKey, verticalConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addConstraints:verticalConstraints];
    }
    else {
        bottomBorderView.hidden = YES;
    }
    
    if (borderOption & WFBorderOptionRight) {
        rightBorderView.hidden = NO;
        rightBorderView.backgroundColor = [self borderColor];
        rightBorderView.isDashed = [self borderDashes].right;
        if (rightBorderView.isDashed) {
            rightBorderView.backgroundColor = [UIColor clearColor];
            rightBorderView.dashColor = [self borderColor];
        }
        [self removeConstraints:objc_getAssociatedObject(self, &WFRightBorderViewHorizontalConstraintsKey)];
        [self removeConstraints:objc_getAssociatedObject(self, &WFRightBorderViewVerticalConstraintsKey)];
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightBorderView(width)]-0-|" options:0 metrics:@{@"width": @([self borderWidths].right)} views:@{@"rightBorderView": rightBorderView}];
        objc_setAssociatedObject(self, &WFRightBorderViewHorizontalConstraintsKey, horizontalConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addConstraints:horizontalConstraints];
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[rightBorderView]-0-|" options:0 metrics:@{@"margin": @([self borderInsets].right)} views:@{@"rightBorderView": rightBorderView}];
        objc_setAssociatedObject(self, &WFRightBorderViewVerticalConstraintsKey, verticalConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addConstraints:verticalConstraints];
    }
    else {
        rightBorderView.hidden = YES;
    }
}

#pragma mark - private setter & getter

- (WFLineView *)topBorderView
{
    WFLineView *topView = objc_getAssociatedObject(self, &WFTopBorderViewKey);
    if (!topView) {
        topView = [[WFLineView alloc] init];
        topView.translatesAutoresizingMaskIntoConstraints = NO;
        [self insertSubview:topView atIndex:100];
        objc_setAssociatedObject(self, &WFTopBorderViewKey, topView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return topView;
}

- (WFLineView *)leftBorderView
{
    WFLineView *leftView = objc_getAssociatedObject(self, &WFLeftBorderViewKey);
    if (!leftView) {
        leftView = [[WFLineView alloc] init];
        leftView.translatesAutoresizingMaskIntoConstraints = NO;
        [self insertSubview:leftView atIndex:101];
        objc_setAssociatedObject(self, &WFLeftBorderViewKey, leftView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return leftView;
}

- (WFLineView *)bottomBorderView
{
    WFLineView *bottomView = objc_getAssociatedObject(self, &WFBottomBorderViewKey);
    if (!bottomView) {
        bottomView = [[WFLineView alloc] init];
        bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        [self insertSubview:bottomView atIndex:102];
        objc_setAssociatedObject(self, &WFBottomBorderViewKey, bottomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return bottomView;
}

- (WFLineView *)rightBorderView
{
    WFLineView *rightView = objc_getAssociatedObject(self, &WFRightBorderViewKey);
    if (!rightView) {
        rightView = [[WFLineView alloc] init];
        rightView.translatesAutoresizingMaskIntoConstraints = NO;
        [self insertSubview:rightView atIndex:103];
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
