//
//  ABFactory.h
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABBaseModel.h"
#import "ArcaneBarrageView.h"

@interface ABFactory : NSObject

+ (ABBaseModel *)createBarrageWithBarrageSource:(ABViewSource *)barrageSource
                                       configuration:(ABViewConfiguration *)configuration;

@end
