//
//  ArcaneBarrageView.h
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABViewSource.h"
#import "ABViewConfiguration.h"
@class ArcaneBarrageView;

@protocol ArcaneBarrageViewDelegate <NSObject>

@required
// 视频播放进度，单位秒
- (float)arcaneBarrageViewGetPlayTime:(ArcaneBarrageView *)view;

// 视频播放缓冲状态，如果设为YES，不会绘制新弹幕，已绘制弹幕会继续动画直至消失
- (BOOL)arcaneBarrageViewIsBuffering:(ArcaneBarrageView *)view;

@optional
// 弹幕初始化完成
- (void)arcaneBarrageViewPerpareComplete:(ArcaneBarrageView *)view;

@end

@interface ArcaneBarrageView : UIView

@property (nonatomic, weak) id<ArcaneBarrageViewDelegate> delegate;

@property (nonatomic, readonly) BOOL isPrepared;
@property (nonatomic, readonly) BOOL isPlaying;

- (instancetype)initWithFrame:(CGRect)frame Configuration:(ABViewConfiguration *)configuration;

// source组成的数组
- (void)prepareArcaneBarrageSources:(NSArray *)sources;

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

- (void)sendArcaneBarrageSource:(ABViewSource *)source;

@end
