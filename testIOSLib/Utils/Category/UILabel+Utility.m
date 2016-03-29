//
//  UILabel+Utility.m
//  ParentChildEducation
//
//  Created by zlan.zhang on 15/5/5.
//  Copyright (c) 2015年 lakeTechnology.com. All rights reserved.
//

#import "UILabel+Utility.h"

#define kTextColor [UIColor colorWithHex:0x888888 alpha:1.0]

@implementation UILabel (Utility)

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText {
    if ((self = [self initWithFrame:CGRectZero]) != nil) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTextColor:kTextColor];
        [self setFont:initFont];
        [self setText:initText];
        CGSize labelSize = [initText sizeWithFont:initFont];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    }

    return self;
}

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor {
    if ((self = [self initWithFrame:CGRectZero]) != nil) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:initFont];
        [self setText:initText];
        [self setTextColor:textColor];
        self.numberOfLines = 0;

        [self setTextAlignment:NSTextAlignmentCenter];
        CGSize labelSize = [initText sizeWithFontCompatible:initFont];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    }

    return self;
}

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor withTag:(NSInteger)initTag {
    if ((self = [self initWithFrame:CGRectZero]) != nil) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:initFont];
        [self setText:initText];
        [self setTextColor:textColor];
        [self setTextAlignment:NSTextAlignmentCenter];
        CGSize labelSize = [initText sizeWithFontCompatible:initFont];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
        self.numberOfLines = 0;

        self.tag = initTag;
    }

    return self;
}

- (id)initRedStart:(UIFont *)initFont;
{
    if ((self = [self initWithFrame:CGRectZero]) != nil) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:initFont];
        [self setText:@"*"];
        [self setTextColor:[UIColor redColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        CGSize labelSize = [@"*" sizeWithFontCompatible:initFont];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    }

    return self;
}

@end
