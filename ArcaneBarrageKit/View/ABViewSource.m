//
//  ABViewSource.m
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import "ABViewSource.h"



@implementation ABViewSource

+ (instancetype)createWithP:(NSString *)p M:(NSString *)m
{
    ABViewSource *source = [[ABViewSource alloc] init];
    source.p = p;
    source.m = m;
    return source;
}

@end
