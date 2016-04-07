//
//  Created by G on 16/03/30.
//  Copyright © 2015年 fangstar. All rights reserved.
//

#ifndef TestLib_GTPublicDefine_h
#define TestLib_GTPublicDefine_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenScale [UIScreen mainScreen].scale

// 颜色
#define kARGBColor(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define kSepartorLineColor kARGBColor(230, 230, 230, 1.0)
#define kBackgroundColor kARGBColor(240, 245, 246, 1.0)
#define kBlueBackGroundColor [UIColor colorWithHex:0x22a7fb alpha:1.0]
#define kTextColor [UIColor colorWithHex:0x888888 alpha:1.0]
#define colorTint [UIColor colorWithRed:34 / 255.0 green:167 / 255.0 blue:251 / 255.0 alpha:1.0]
#define colorDarkText [UIColor colorWithHex:0x333333 alpha:1.0]
#define colorLightText [UIColor colorWithHex:0x666666 alpha:1.0]
#define kLabelColor [UIColor colorWithRed:0.34 green:0.34 blue:0.35 alpha:1]
#define colorNull [UIColor colorWithRed:3 / 255.0 green:3 / 255.0 blue:3 / 255.0 alpha:1.0]
#define colorLine [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1.0]
#define colorGray [UIColor colorWithHex:0xE2E2E2 alpha:1.0]

// 字体
#define kCurNormalFontOfSize(fontSize) [UIFont systemFontOfSize:fontSize]
#define kSmallFont [UIFont systemFontOfSize:12]

// 系统
#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

// 判断iPhone4
#define isIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPhone5
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iphone6
#define isIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iphone6+
#define isIPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#endif
