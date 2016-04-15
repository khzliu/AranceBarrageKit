//
//  ABBaseModel.h
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ABRetainer,ABLabel;

typedef NS_ENUM(NSUInteger, ArcaneBarrageType){
    ArcaneBarrageTypeLeftToRight = 0,
    ArcaneBarrageTypeForTop      = 1,
    ArcaneBarrageTypeForButtom   = 2
};

typedef NS_ENUM(NSUInteger, ArcaneBarrageFontSize){
    ArcaneBarrageFontSizeNormal = 0,
    ArcaneBarrageFontSizeLarge  = 1,
};

@interface ABBaseModel : NSObject

@property (nonatomic, assign) ArcaneBarrageType abType;

@property (nonatomic, assign) float time;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) float remainTime;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor  *textColor;
@property (nonatomic, assign) float     textSize;

@property (nonatomic, assign) float  px;
@property (nonatomic, assign) float  py;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL   isMeasured;

@property (nonatomic, assign) BOOL   isShowing;
@property (nonatomic, strong) ABLabel  *label;
@property (nonatomic, weak) ABRetainer *retainer;

@property (nonatomic, assign) BOOL isSelfID;

- (void)measureSizeWithPaintHeight:(CGFloat)paintHeight;
- (void)layoutWithScreenWidth:(float)width;
- (float)pxWithScreenWidth:(float)width remainTime:(float)remainTime;

- (BOOL)isDraw:(float)curTime;
- (BOOL)isLate:(float)curTime;

@end

@interface ABLeftToRightModel : ABBaseModel

@end

@interface ABFromTopModel : ABBaseModel

@end

@interface ABFromButtomModel : ABFromTopModel

@end
