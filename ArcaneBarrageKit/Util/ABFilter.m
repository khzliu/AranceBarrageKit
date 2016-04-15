//
//  ABFilter.m
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import "ABFilter.h"
#import "ABBaseModel.h"

@implementation ABFilter


- (NSArray *)filterBarrages:(NSArray *)barrages time:(ABTime *)time
{
    if (barrages.count<1) {
        return nil;
    }
    ABBaseModel *lastBarrage = barrages.lastObject;
    if (![lastBarrage isDraw:time.time]) {
        return nil;
    }
    ABBaseModel *firstBarrage = barrages.firstObject;
    if ([firstBarrage isDraw:time.time]) {
        return barrages;
    }
    return [self cutWithBarrages:barrages time:time];
}

- (NSArray *)cutWithBarrages:(NSArray *)barrages time:(ABTime *)time
{
    NSUInteger count = barrages.count;
    NSUInteger index, minIndex=0, maxIndex = count-1;
    ABBaseModel *barrage = nil;
    while (maxIndex-minIndex>1) {
        index = (maxIndex+minIndex)/2;
        barrage = barrages[index];
        if ([barrage isDraw:time.time]) {
            maxIndex = index;
        } else {
            minIndex = index;
        }
    }
    return [barrages subarrayWithRange:NSMakeRange(maxIndex, count-maxIndex)];
}

@end
