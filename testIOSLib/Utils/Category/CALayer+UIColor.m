//
//  CALayer+UIColor.m
//  FangStarBroker
//
//  Created by zhanglan on 15/12/15.
//  Copyright © 2015年 fangstar. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
