//
//  ABRetainer.h
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ArcaneBarrageView.h"

@class ABBaseModel;

@interface ABRetainer : NSObject

@property (nonatomic, assign) CGSize canvasSize;
@property (nonatomic, weak) ABViewConfiguration *configuration;

- (void)clearVisibleArcaneBarrage:(ABBaseModel *)barrage;
- (float)layoutPyForArcaneBarrage:(ABBaseModel *)barrage;
- (void)clear;

@end

@interface ABForTopRetainer : ABRetainer

@end

@interface ABForButtomRetainer : ABForTopRetainer

@end