//
//  BaseAlert.m
//  fangstarnet
//
//  Created by XuLei on 15/8/30.
//  Copyright (c) 2015年 fangstar. All rights reserved.
//

#import "BaseAlert.h"
#import "Utils.h"

@implementation BaseAlert
{
    MBProgressHUD *_HUD;
}

+ (id)sharedInstance
{
    static BaseAlert *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      sharedInstance = [[[self class] alloc] init];
                  });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        
        
    }
    return self;
}

- (void)showMessage:(NSString *)msg
{
    for (id objc in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([objc isKindOfClass:[MBProgressHUD class]])
        {
            [objc removeFromSuperview];
        }
    }
    UILabel *tipLab= [[UILabel alloc] init];
    tipLab.backgroundColor = [UIColor clearColor];
    
    tipLab.numberOfLines = 0;
    tipLab.lineBreakMode = NSLineBreakByCharWrapping;
    tipLab.text = msg;
    tipLab.textColor = [UIColor whiteColor];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:16.0f];
    
    
   CGSize textSize = [msg sizeWithFontCompatible:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(ScreenWidth-80, ScreenHeight) lineBreakMode:NSLineBreakByTruncatingTail];
    
//    CGFloat textWidth = [FMUString widthForText:msg withTextHeigh:16 withFont:[UIFont systemFontOfSize:16.0f]];
//    textWidth = textWidth>ScreenWidth-40? ScreenWidth-40:textWidth;
//    CGFloat textHeight = [FMUString heightForText:msg withTextWidth:textWidth withFont:[UIFont systemFontOfSize:16.0f]];
    tipLab.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    _HUD = [[MBProgressHUD alloc] init];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.animationType = MBProgressHUDAnimationFade;
    _HUD.customView = tipLab;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    
    [_HUD show:YES];
    
    [_HUD hide:YES afterDelay:2];
}

- (void)showLodingWithMessage:(NSString *)msg
{
    for (id objc in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([objc isKindOfClass:[MBProgressHUD class]])
        {
            [objc removeFromSuperview];
        }
    }
    _HUD = [[MBProgressHUD alloc] init];
    _HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    [_HUD show:YES];
    _HUD.labelFont = [UIFont systemFontOfSize:12.0f];
    _HUD.labelText = msg;
}

- (void)showIndex:(NSString *)msg
{
    MBProgressHUD *HUD = [Utils createHUD];
    
    HUD.mode = MBProgressHUDModeText;
    HUD.animationType = MBProgressHUDAnimationFade;
    HUD.labelText = msg;
    HUD.labelFont = [UIFont systemFontOfSize:14.0f];
    [HUD hide:YES afterDelay:0.5];
}

- (void)dismiss
{
    if (_HUD) {
        [_HUD hide:YES];
    }
}
@end
