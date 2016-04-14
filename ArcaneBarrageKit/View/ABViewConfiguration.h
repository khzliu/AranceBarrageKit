//
//  ABViewConfiguration.h
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ABViewConfiguration : NSObject

@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat paintHeight;

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat largeFontSize;

@property (nonatomic, assign) CGFloat maxLRShowCount;
@property (nonatomic, assign) CGFloat maxShowCount;

//发送弹幕是否显示下划线
@property (nonatomic, assign) BOOL    isShowLineWhenSelf;

@end
