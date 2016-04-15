//
//  ABRenderer.m
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import "ABRenderer.h"

#import "ABBaseModel.h"
#import "ABRetainer.h"
#import "ABTime.h"
#import "ArcaneBarrageView.h"
#import "ABLabel.h"

@interface ABRenderer () {
    float _canvasWidth;
    NSMutableArray *_drawArray;
    NSMutableArray *_cacheLabels;
}

@property (nonatomic, weak) UIView *canvas;
@property (nonatomic, strong) ABRetainer *barrageLeftToRightRetainer;
@property (nonatomic, strong) ABRetainer *barrageForTopRetainer;
@property (nonatomic, strong) ABRetainer *barrageForButtomRetainer;


@end

@implementation ABRenderer

- (instancetype)initWithCanvas:(UIView *)canvas configuration:(ABViewConfiguration *)configuration
{
    if (self = [super init]) {
        _barrageLeftToRightRetainer = [[ABRetainer alloc] init];
        _barrageForTopRetainer = [[ABForTopRetainer alloc] init];
        _barrageForButtomRetainer = [[ABForButtomRetainer alloc] init];
        [self setConfiguration:configuration];
        self.canvas = canvas;
        [self setCanvasFrameSize];
    }
    return self;
}

- (void)setConfiguration:(ABViewConfiguration *)configuration
{
    [self stopRenderer];
    NSInteger count = configuration.maxShowCount+5;
    _drawArray = [[NSMutableArray alloc] initWithCapacity:count];
    _cacheLabels = [[NSMutableArray alloc] initWithCapacity:count];
    _configuration = configuration;
    _barrageLeftToRightRetainer.configuration = configuration;
    _barrageForTopRetainer.configuration = configuration;
    _barrageForButtomRetainer.configuration = configuration;
}

- (void)setCanvasFrameSize
{
    _canvasWidth = CGRectGetWidth(self.canvas.frame);
    _barrageLeftToRightRetainer.canvasSize = self.canvas.frame.size;
    _barrageForTopRetainer.canvasSize = self.canvas.frame.size;
    _barrageForButtomRetainer.canvasSize = self.canvas.frame.size;
}

- (void)updateCanvasFrame
{
    [self setCanvasFrameSize];
    
    [self.barrageForTopRetainer clear];
    [self.barrageForButtomRetainer clear];
    for (NSInteger index=0; index<_drawArray.count; index++) {
        ABBaseModel *barrage = _drawArray[index];
        if (barrage.abType!=ArcaneBarrageTypeLeftToRight) {
            barrage.isShowing = NO;
            [self rendererBarrage:barrage];
        }
        
        if (CGRectGetMaxY(barrage.label.frame)>CGRectGetHeight(self.canvas.frame)) {
            [self removeBarrage:barrage];
            [_drawArray removeObjectAtIndex:index];
        } else {
            barrage.isShowing = YES;
        }
    }
}

#pragma mark - Label
- (void)removeLabelForBarrage:(ABBaseModel *)barrage
{
    UILabel *cacheLabel = barrage.label;
    if (cacheLabel) {
        [cacheLabel.layer removeAllAnimations];
        [_cacheLabels addObject:cacheLabel];
        barrage.label = nil;
    }
}

- (void)createLabelForBarrage:(ABBaseModel *)barrage
{
    if (barrage.label) {
        return;
    }
    if (_cacheLabels.count<1) {
        barrage.label = [[ABLabel alloc] init];
        barrage.label.backgroundColor = [UIColor clearColor];
    } else {
        barrage.label = [_cacheLabels lastObject];
        [_cacheLabels removeLastObject];
    }
}

#pragma mark - Draw
- (void)drawBarrages:(NSArray *)barrages time:(ABTime *)time isBuffering:(BOOL)isBuffering
{
    int LRShowCount = 0;
    for (NSInteger index=0; index<_drawArray.count;) {
        ABBaseModel *barrage = _drawArray[index];
        barrage.remainTime -= time.interval;
        if (barrage.remainTime<0) {
            [self removeBarrage:barrage];
            [_drawArray removeObjectAtIndex:index];
            continue;
        }
        if (barrage.abType==ArcaneBarrageTypeLeftToRight) {
            LRShowCount++;
        }
        [self rendererBarrage:barrage];
        index++;
    }
    if (isBuffering) {
        return;
    }
    for (ABBaseModel *barrage in [barrages objectEnumerator]) {
        if ([barrage isLate:time.time]) {
            break;
        }
        if (_drawArray.count>=self.configuration.maxShowCount && !barrage.isSelfID) {
            break;
        }
        if (barrage.isShowing) {
            continue;
        }
        if (![barrage isDraw:time.time]) {
            continue;
        }
        if (barrage.abType==ArcaneBarrageTypeLeftToRight) {
            if (LRShowCount>self.configuration.maxLRShowCount && !barrage.isSelfID) {
                continue;
            } else {
                LRShowCount++;
            }
        }
        [self createLabelForBarrage:barrage];
        [self rendererBarrageLabel:barrage];
        [_drawArray addObject:barrage];
        barrage.remainTime = barrage.time-time.time+barrage.duration;
        barrage.retainer = [self getHitDicForType:barrage.abType];
        [self rendererBarrage:barrage];
        if (barrage.py>=0) {
            NSInteger zIndex = barrage.abType==ArcaneBarrageTypeLeftToRight?0:10;
            [self.canvas insertSubview:barrage.label atIndex:zIndex];
            barrage.isShowing = YES;
        }
    }
}

- (void)removeBarrage:(ABBaseModel *)barrage
{
    [barrage.retainer clearVisibleArcaneBarrage:barrage];
    barrage.retainer = nil;
    [barrage.label removeFromSuperview];
    barrage.isShowing = NO;
    [self removeLabelForBarrage:barrage];
}

- (ABRetainer *)getHitDicForType:(ArcaneBarrageType)type
{
    switch (type) {
        case ArcaneBarrageTypeLeftToRight:return _barrageLeftToRightRetainer;
        case ArcaneBarrageTypeForTop:return _barrageForTopRetainer;
        case ArcaneBarrageTypeForButtom:return _barrageForButtomRetainer;
    }
}

#pragma mark - Renderer
- (void)rendererBarrageLabel:(ABBaseModel *)barrage
{
    [barrage measureSizeWithPaintHeight:self.configuration.paintHeight];
    barrage.label.alpha = 1;
    barrage.label.font = [UIFont systemFontOfSize:barrage.textSize];
    barrage.label.text = barrage.text;
    barrage.label.textColor = barrage.textColor;
    barrage.label.underLineEnable = barrage.isSelfID;
}

- (void)rendererBarrage:(ABBaseModel *)barrage
{
    [barrage layoutWithScreenWidth:_canvasWidth];
    if (!barrage.isShowing) {
        float py = [barrage.retainer layoutPyForArcaneBarrage:barrage];
        if (py<0) {
            if (barrage.isSelfID) {
                py = barrage.abType!=ArcaneBarrageTypeForButtom?0:(CGRectGetHeight(self.canvas.frame)-self.configuration.paintHeight);
            } else {
                barrage.remainTime = -1;
            }
        }
        barrage.py = py;
    } else if (barrage.abType!=ArcaneBarrageTypeLeftToRight) {
        return;
    }
    if (barrage.isShowing) {
        [UIView animateWithDuration:barrage.remainTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            barrage.label.frame = CGRectMake(-barrage.size.width, barrage.py, barrage.size.width, barrage.size.height);
        } completion:nil];
    } else {
        barrage.label.frame = CGRectMake(barrage.px, barrage.py, barrage.size.width, barrage.size.height);
    }
}

#pragma mark -
- (void)pauseRenderer
{
    for (ABBaseModel *barrage in _drawArray.objectEnumerator) {
        if (barrage.abType!=ArcaneBarrageTypeLeftToRight) {
            continue;
        }
        CALayer *layer = barrage.label.layer;
        CGRect rect = barrage.label.frame;
        if (layer.presentationLayer) {
            rect = ((CALayer *)layer.presentationLayer).frame;
            rect.origin.x-=1;
        }
        barrage.label.frame = rect;
        [barrage.label.layer removeAllAnimations];
    }
}

- (void)stopRenderer
{
    for (ABBaseModel *barrage in _drawArray.objectEnumerator) {
        [barrage.label removeFromSuperview];
        [self removeLabelForBarrage:barrage];
        barrage.remainTime = -1;
        barrage.isShowing = NO;
        barrage.retainer = nil;
    }
    [_drawArray removeAllObjects];
    [self.barrageLeftToRightRetainer clear];
    [self.barrageForTopRetainer clear];
    [self.barrageForButtomRetainer clear];
}

@end
