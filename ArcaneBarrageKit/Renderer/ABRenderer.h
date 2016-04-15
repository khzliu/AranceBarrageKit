//
//  ABRenderer.h
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ABTime,ABViewConfiguration;

@interface ABRenderer : NSObject

@property (nonatomic, weak) ABViewConfiguration *configuration;

- (instancetype)initWithCanvas:(UIView *)canvas configuration:(ABViewConfiguration *)configuration;
- (void)updateCanvasFrame;

- (void)drawBarrages:(NSArray *)barrages time:(ABTime *)time isBuffering:(BOOL)isBuffering;

- (void)pauseRenderer;
- (void)stopRenderer;

@end
