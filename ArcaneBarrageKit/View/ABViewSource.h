//
//  ABViewSource.h
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import <Foundation/Foundation.h>

//_______________________________________________________________________________________________________________

// 时间(毫秒),类型(0:向左滚动 1:顶部 2底部),字体大小(0:中字体 1:大字体),颜色(16进制),用户ID
// "p": "25,1,0,FFFFFF,0",
// "m": "olinone.com"

@interface ABViewSource : NSObject

@property (nonatomic, strong) NSString *p;
@property (nonatomic, strong) NSString *m;

+ (instancetype)createWithP:(NSString *)p M:(NSString *)m;

@end
