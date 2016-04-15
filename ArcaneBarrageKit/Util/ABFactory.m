//
//  ABFactory.m
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import "ABFactory.h"

@implementation ABFactory

+ (ABBaseModel *)createBarrageWithBarrageSource:(ABViewSource *)barrageSource
                                  configuration:(ABViewConfiguration *)configuration
{
    NSString *pString = barrageSource.p;
    NSString *mString = barrageSource.m;
    if (pString.length<1 || mString.length<1) {
        return nil;
    }
    NSArray *pArray = [pString componentsSeparatedByString:@","];
    if (pArray.count<5) {
        return  nil;
    }
    
    ArcaneBarrageType type = [pArray[1] integerValue]%3;
    ArcaneBarrageFontSize fontSize = [pArray[2] integerValue]%2;
    
    ABBaseModel *barrage = [ABFactory createBarrageWithBarrageType:type
                                                               configuration:configuration];
    barrage.time = [pArray[0] floatValue]/1000.0;
    barrage.text = mString;
    barrage.textSize = fontSize==ArcaneBarrageFontSizeLarge?configuration.largeFontSize:configuration.fontSize;
    barrage.textColor = [self colorWithHexStr:pArray[3]];
    return barrage;
}

+ (ABBaseModel *)createBarrageWithBarrageType:(ArcaneBarrageType)type
                                     configuration:(ABViewConfiguration *)configuration
{
    ABBaseModel *barrage = nil;
    switch (type) {
        case ArcaneBarrageTypeLeftToRight:
            barrage = [[ABLeftToRightModel alloc] init];
            barrage.abType = ArcaneBarrageTypeLeftToRight;
            break;
        case ArcaneBarrageTypeForTop:
            barrage = [[ABFromTopModel alloc] init];
            barrage.abType = ArcaneBarrageTypeForTop;
            break;
        case ArcaneBarrageTypeForButtom:
            barrage = [[ABFromButtomModel alloc] init];
            barrage.abType = ArcaneBarrageTypeForButtom;
            break;
    }
    barrage.duration = configuration.duration;
    return barrage;
}

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
+ (UIColor *)colorWithHexStr:(NSString *)str
{
    int i = 0;
    if ([str characterAtIndex:0] == '#')
        i = 1;
    
    if (i + 6 > [str length])
        return [UIColor blackColor];
    
    return RGBCOLOR([self intWithC1:[str characterAtIndex:i]
                                 C2:[str characterAtIndex:i + 1]],
                    [self intWithC1:[str characterAtIndex:i + 2]
                                 C2:[str characterAtIndex:i + 3]],
                    [self intWithC1:[str characterAtIndex:i + 4]
                                 C2:[str characterAtIndex:i + 5]]);
}

+ (int)intWithC1:(char)c1 C2:(char)c2
{
    int s = [self intWithChar:c1] * 16 + [self intWithChar:c2];
    return s;
}

+ (int)intWithChar:(char) c
{
    int r = 0;
    if (c >= '0' && c <= '9')
        r = c - '0';
    else if (c >= 'a' && c <= 'z')
        r = c - 'a' + 10;
    else if (c >= 'A' && c <= 'Z')
        r = c - 'A' + 10;
    return r;
}

@end
