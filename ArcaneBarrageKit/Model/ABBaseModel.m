//
//  ABBaseModel.m
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import "ABBaseModel.h"
#import "ArcaneBarrageView.h"
#import "ABLabel.h"

@implementation ABBaseModel

- (void)measureSizeWithPaintHeight:(CGFloat)paintHeight;
{
    if (self.isMeasured) {
        return;
    }

    UIFont* font = [UIFont systemFontOfSize:self.textSize];
    self.size = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, paintHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    self.isMeasured = YES;
}

- (void)layoutWithScreenWidth:(float)width;
{
    
}

- (float)pxWithScreenWidth:(float)width remainTime:(float)remainTime
{
    return -self.size.width;
}

- (BOOL)isDraw:(float)curTime
{
    return self.time>=curTime;
}

- (BOOL)isLate:(float)curTime
{
    return (curTime+1)<self.time;
}

@end

@implementation ABLeftToRightModel

- (void)layoutWithScreenWidth:(float)width;
{
    self.px = [self pxWithScreenWidth:width RemainTime:self.remainTime];
}

- (float)pxWithScreenWidth:(float)width RemainTime:(float)remainTime
{
    return -self.size.width+(width+self.size.width)/self.duration*remainTime;
}

@end

@implementation ABFromTopModel

- (void)layoutWithScreenWidth:(float)width;
{
    self.px = (width-self.size.width)/2;
    float alpha = 0;
    if (self.remainTime>0 && self.remainTime<self.duration) {
        alpha= 1;
    }
    self.label.alpha = alpha;
}

@end

@implementation ABFromButtomModel

@end
