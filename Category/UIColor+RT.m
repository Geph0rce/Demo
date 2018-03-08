//
//  UIColor+RT.m
//  UIComponents
//
//  Created by 丛 贵明 on 12/19/13.
//  Copyright (c) 2013 anjuke inc. All rights reserved.
//

#import "UIColor+RT.h"

@implementation UIColor (RT)

+ (UIColor *) colorWithHex:(uint) hex alpha:(CGFloat)alpha
{
	int red, green, blue;
	
	blue = hex & 0x0000FF;
	green = ((hex & 0x00FF00) >> 8);
	red = ((hex & 0xFF0000) >> 16);
	
	return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)ajkBlackColor {
    return [UIColor colorWithHex:0x333333 alpha:1];
}

+ (UIColor *)ajkDarkGrayColor {
    return [UIColor colorWithHex:0x666666 alpha:1];
}

+ (UIColor *)ajkMiddleGrayColor {
    return [UIColor colorWithHex:0x999999 alpha:1];
}

+ (UIColor *)ajkLightGrayColor {
    return [UIColor colorWithHex:0xcccccc alpha:1];
}

+ (UIColor *)ajkWhiteGreyColor {
    return [UIColor colorWithHex:0xdddddd alpha:1];
}

+ (UIColor *)ajkMidWhiteGreyColor {
    return [UIColor colorWithHex:0xebebeb alpha:1];
}

+ (UIColor *)ajkLightWhiteGreyColor {
    return [UIColor colorWithHex:0xeeeeee alpha:1];
}

+ (UIColor *)ajkPaleGreenColor {
    return [UIColor colorWithHex:0XEDFFE7 alpha:1];
}

+ (UIColor *)ajkGreenColor {
    return [UIColor colorWithHex:0X3CB950 alpha:1];
}

+ (UIColor *)ajkNewGreenColor {
    return [UIColor colorWithHex:0X1FC063 alpha:1];
}

+ (UIColor *)ajkDarkGreenColor {
    return [UIColor colorWithHex:0X29A03C alpha:1];
}

+ (UIColor *)ajkOrangeColor {
    return [UIColor colorWithHex:0xe54b00 alpha:1];
}

+ (UIColor *)ajkDarkOrangeColor {
    return [UIColor colorWithHex:0XC34100 alpha:1];
}

+ (UIColor *)ajkGreenlinkColor {
    return [UIColor colorWithHex:0X62AB00 alpha:1];
}

+ (UIColor *)ajkWhiteColor {
    return [UIColor colorWithHex:0xffffff alpha:1];
}

+ (UIColor *)ajkBackgroundPageColor {
    return [UIColor colorWithHex:0XF6F6F6 alpha:1];
}

+ (UIColor *)ajkBackgroundBarColor {
    return [UIColor colorWithHex:0xf8f8f9 alpha:1];
}

+ (UIColor *)ajkBackgroundContentColor {
    return [UIColor colorWithHex:0xffffff alpha:1];
}

+ (UIColor *)ajkLineColor {
    return [UIColor colorWithHex:0XE6E6E6 alpha:1];
}

+ (UIColor *)ajkBgSelectColor {
    return [UIColor colorWithHex:0xEAEAEA alpha:1];
}

+ (UIColor *)ajkBtnText {
    return [UIColor colorWithHex:0x3c3c3d alpha:1];
}

+ (UIColor *)ajkChatBlueColor {
    return [UIColor colorWithHex:0x375aa2 alpha:1];
}

+ (UIColor *)ajkBgNavigationColor {
    return [UIColor colorWithHex:0XF6F6F6 alpha:1];
}

+ (UIColor *)ajkBgTitleColor {
    return [UIColor colorWithHex:0X333333 alpha:1];
}

+ (UIColor *)ajkBgActionColor {
    return [UIColor colorWithHex:0x262626 alpha:1];
}

+ (UIColor *)ajkBgTabColor {
    return [UIColor colorWithHex:0xf6f6f6 alpha:1];
}

+ (UIColor *)ajkBgTagColor {
    return [UIColor colorWithHex:0xE7F1DB alpha:1];
}

+ (UIColor *)ajkGrayLine1Color{
    return [self colorWithHex:0xc6c6c6 alpha:1];
}

+ (UIColor *)ajkGrayLine2Color
{
    return [self colorWithHex:0xCFCFCF alpha:1];
}

+ (UIColor *)ajkBorderColor
{
    return [UIColor colorWithHex:0xeeeeee alpha:1];
}

+ (UIColor *)ajkFilterSelectedColor
{
    return [UIColor colorWithHex:0x5da500 alpha:1];
}

+ (UIColor *)ajkFilterCellSeparatorLineColor
{
    return [UIColor colorWithRed:.783922 green:.780392 blue:.8 alpha:1];
}

+ (UIColor *)ajkTipsColor
{
    return [UIColor colorWithHex:0XFFA400 alpha:1];
}

+ (UIColor *)ajkLineNavColor
{
    return [UIColor colorWithHex:0XCCCCCC alpha:1];
}

+ (UIColor *)ajkBgInputColor
{
    return [UIColor colorWithHex:0XE6E6E6 alpha:1];
}

+ (UIColor *)ajkBlueColor
{
    return [UIColor colorWithHex:0X8099AF alpha:1];
}

+ (UIColor *)ajkBgButtonColor
{
    return [UIColor colorWithHex:0XF8F8F8 alpha:1];
}

+ (UIColor *)ajkDarkBlackColor
{
    return [UIColor colorWithHex:0X000000 alpha:1];
}

+ (UIColor *)ajkBrandGreenColor
{
    return [UIColor colorWithHex:0X1AAD00 alpha:1];
}

+ (UIColor *)ajkTextGreenColor
{
    return [UIColor colorWithHex:0X3CB950 alpha:1];
}

+ (UIColor *)ajkTagGreenColor
{
    return [UIColor colorWithHex:0X5EC86F alpha:1];
}

+ (UIColor *)ajkBgTagGreenColor
{
    return [UIColor colorWithHex:0XEDFBEE alpha:1];
}

+ (UIColor *)ajkTagOrangeColor
{
    return [UIColor colorWithHex:0XFFA626 alpha:1];
}

+ (UIColor *)ajkBgTagOrangeColor
{
    return [UIColor colorWithHex:0XFFF3E6 alpha:1];
}

+ (UIColor *)ajkTagBlueColor
{
    return [UIColor colorWithHex:0X7BBDEB alpha:1];
}

+ (UIColor *)ajkBgTagBlueColor
{
    return [UIColor colorWithHex:0XECF5FF alpha:1];
}

+ (UIColor *)ajkBgBlueColor
{
    return [UIColor colorWithHex:0XFAFBFD alpha:1];
}

+ (UIColor *)ajkSaffronYellowColor {
    return [UIColor colorWithHex:0xFF8700 alpha:1];
}

@end
