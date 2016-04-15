//
//  ABFilter.h
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABTime.h"

@interface ABFilter : NSObject

- (NSArray *)filterBarrages:(NSArray *)barrages time:(ABTime *)time;


@end
