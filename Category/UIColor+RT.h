//
//  UIColor+RT.h
//  UIComponents
//
//  Created by 丛 贵明 on 12/19/13.
//  Copyright (c) 2013 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RT)

+ (UIColor *)colorWithHex:(uint) hex alpha:(CGFloat)alpha;

//标题大字，正文内容 38,38,38
+ (UIColor *)ajkBlackColor;

//小标题，附属说明文字 85,85,85
+ (UIColor *)ajkDarkGrayColor;

//小标题，附属说明文字 150,150,150
+ (UIColor *)ajkMiddleGrayColor;

//输入框内的提示文字 204,204,206
+ (UIColor *)ajkLightGrayColor;

+ (UIColor *)ajkWhiteGreyColor;

+ (UIColor *)ajkMidWhiteGreyColor;

+ (UIColor *)ajkLightWhiteGreyColor;

//255,255,255
+ (UIColor *)ajkWhiteColor;

//按钮文字，链接文字 100,169,0
+ (UIColor *)ajkGreenColor;

+ (UIColor *)ajkNewGreenColor;

//房价，套数 229,75,0
+ (UIColor *)ajkOrangeColor;

//各页面背景 244,244,244
+ (UIColor *)ajkBackgroundPageColor;

//部分栏的背景色 248,248,249
+ (UIColor *)ajkBackgroundBarColor;

//内容区的背景色 255,255,255
+ (UIColor *)ajkBackgroundContentColor;

//页面和列表的分割线 204,204,204
+ (UIColor *)ajkLineColor;

//选中背景色 234,234,234
+ (UIColor *)ajkBgSelectColor;

//深绿 35,140,0
+ (UIColor *)ajkDarkGreenColor;

//文字按钮色 60,60,61
+ (UIColor *)ajkBtnText;

//蓝色 55,90,162
+ (UIColor *)ajkChatBlueColor;

//导航栏背景色 244,244,244
+ (UIColor *)ajkBgNavigationColor;

//导航栏标题色 102,102,102
+ (UIColor *)ajkBgTitleColor;

//导航栏动作色 38,38,38
+ (UIColor *)ajkBgActionColor;

//标签栏背景色 246,246,246
+ (UIColor *)ajkBgTabColor;

+ (UIColor *)ajkBgTagColor;

+ (UIColor *)ajkGrayLine1Color;

+ (UIColor *)ajkGrayLine2Color;

+ (UIColor *)ajkBorderColor;

+ (UIColor *)ajkFilterSelectedColor;

+ (UIColor *)ajkFilterCellSeparatorLineColor;

+ (UIColor *)ajkTipsColor;

+ (UIColor *)ajkPaleGreenColor;

+ (UIColor *)ajkDarkOrangeColor;

+ (UIColor *)ajkGreenlinkColor;

+ (UIColor *)ajkBgInputColor;

+ (UIColor *)ajkLineNavColor;

+ (UIColor *)ajkBlueColor;

+ (UIColor *)ajkBgButtonColor;


+ (UIColor *)ajkDarkBlackColor;

+ (UIColor *)ajkBrandGreenColor;

+ (UIColor *)ajkTextGreenColor;

+ (UIColor *)ajkTagGreenColor;

+ (UIColor *)ajkBgTagGreenColor;

+ (UIColor *)ajkTagOrangeColor;

+ (UIColor *)ajkBgTagOrangeColor;

+ (UIColor *)ajkTagBlueColor;

+ (UIColor *)ajkBgTagBlueColor;

+ (UIColor *)ajkBgBlueColor;

+ (UIColor *)ajkSaffronYellowColor;

@end
