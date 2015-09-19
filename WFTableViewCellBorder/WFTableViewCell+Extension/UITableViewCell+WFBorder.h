//
//  UITableViewCell+WFBorder.h
//  WFTableViewCellBorder
//
//  Created by feiwu on 15/9/19.
//  Copyright (c) 2015年 feiwu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, WFBorderOption) {
    WFBorderOptionNone = 0, // none
    WFBorderOptionTop = 1 << 0, // top
    WFBorderOptionLeft = 1 << 1, // left
    WFBorderOptionBottom = 1 << 2, // bottom
    WFBorderOptionRight = 1 << 3, // right
};

@interface UITableViewCell (WFBorder)

@property (nonatomic, assign) WFBorderOption borderOption;

@property (nonatomic, assign) UIEdgeInsets borderInsets;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) UIEdgeInsets borderWidths;

@end
