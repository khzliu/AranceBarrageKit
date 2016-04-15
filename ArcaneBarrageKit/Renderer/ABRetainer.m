//
//  ABRetainer.m
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import "ABRetainer.h"
#import "ABBaseModel.h"

@interface ABRetainer()

@property (nonatomic, strong) NSMutableDictionary *hitBarrages;
@property (nonatomic, assign) NSInteger maxPyIndex;

@end

@implementation ABRetainer

- (instancetype)init
{
    if (self = [super init]) {
        _hitBarrages = [[NSMutableDictionary alloc] initWithCapacity:self.configuration.maxShowCount+5];;
    }
    return self;
}

- (void)setCanvasSize:(CGSize)canvasSize
{
    _canvasSize = canvasSize;
    self.maxPyIndex = canvasSize.height/self.configuration.paintHeight;
}

- (void)clearVisibleArcaneBarrage:(ABBaseModel *)barrage
{
    u_int8_t pyIndex = barrage.py/self.configuration.paintHeight;
    id key = @(pyIndex);
    ABBaseModel *hitBarrage = self.hitBarrages[key];
    if (hitBarrage==barrage) {
        [self.hitBarrages removeObjectForKey:key];
    }
}

- (float)layoutPyForArcaneBarrage:(ABBaseModel *)barrage
{
    float py = -self.configuration.paintHeight;
    ABBaseModel *tempBarrage = nil;
    for (u_int8_t index = 0; index<_maxPyIndex; index++) {
        tempBarrage = self.hitBarrages[@(index)];
        if (!tempBarrage) {
            self.hitBarrages[@(index)] = barrage;
            py = [self getpyDicForType:barrage.abType index:index];
            break;
        }
        if (![self checkIsWillHitWithWidth:_canvasSize.width barrageLeft:tempBarrage arrageRight:barrage]) {
            self.hitBarrages[@(index)] = barrage;
            py = [self getpyDicForType:barrage.abType index:index];
            break;
        }
    }
    return py;
}

- (float )getpyDicForType:(ArcaneBarrageType)type index:(u_int8_t)index
{
    return index*self.configuration.paintHeight;
}

- (BOOL)checkIsWillHitWithWidth:(float)width barrageLeft:(ABBaseModel *)barrageL arrageRight:(ABBaseModel *)barrageR
{
    if (barrageL.remainTime<=0) {
        return NO;
    }
    if (barrageL.px+barrageL.size.width>barrageR.px) {
        return YES;
    }
    float minRemainTime = MIN(barrageL.remainTime, barrageR.remainTime);
    float px1 = [barrageL pxWithScreenWidth:width remainTime:(barrageL.remainTime-minRemainTime)];
    float px2 = [barrageR pxWithScreenWidth:width remainTime:(barrageR.remainTime-minRemainTime)];
    if (px1+barrageL.size.width>px2) {
        return YES;
    }
    return NO;
}

- (void)clear
{
    [_hitBarrages removeAllObjects];
}

@end

@implementation ABForTopRetainer

- (void)setCanvasSize:(CGSize)canvasSize
{
    [super setCanvasSize:canvasSize];
    self.maxPyIndex /=2;
}

- (BOOL)checkIsWillHitWithWidth:(float)width barrageLeft:(ABBaseModel *)barrageL barrageRight:(ABBaseModel *)barrageR
{
    if (barrageL.remainTime<=0) {
        return NO;
    }
    return YES;
}

@end

@implementation ABForButtomRetainer

- (float )getpyDicForType:(ArcaneBarrageType)type index:(u_int8_t)index
{
    return self.canvasSize.height-self.configuration.paintHeight*(index+1);
}

@end
