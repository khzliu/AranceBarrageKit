//
//  ArcaneBarrageView.m
//  ArcaneBarrageKitDemo
//
//  Created by 刘华舟 on 16/4/14.
//  Copyright © 2016年 khzliu. All rights reserved.
//

#import "ArcaneBarrageView.h"
#import "ABFactory.h"
#import "ABFilter.h"
#import "ABRenderer.h"
#import "ABTime.h"

#define ArcaneBarrageFilterInterval     5

@interface ArcaneBarrageView(){
    NSTimer *_timer;
    float    _timeCount;
    float    _frameInterval;
    ABTime  *_barrageTime;
}

@property (nonatomic, strong) ABViewConfiguration *configuration;

@property (nonatomic, assign) BOOL isPrepared;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isPreFilter;

@property (nonatomic, strong) NSArray  *barrages;
@property (nonatomic, strong) NSArray  *curBarrages;

@property (nonatomic, strong) ABFilter   *filter;
@property (nonatomic, strong) ABRenderer *renderer;

@end

@implementation ArcaneBarrageView

- (instancetype)initWithFrame:(CGRect)frame Configuration:(ABViewConfiguration *)configuration
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.configuration = configuration;
        _frameInterval = 0.5;
        _barrageTime = [[ABTime alloc] init];
        _filter = [[ABFilter alloc] init];
        _renderer = [[ABRenderer alloc] initWithCanvas:self configuration:configuration];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [_renderer updateCanvasFrame];
    }
}


// source组成的数组
- (void)prepareArcaneBarrageSources:(NSArray *)sources
{
    self.isPrepared = NO;
    self.barrages = nil;
    self.curBarrages = nil;
    NSArray *items = sources;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *barrages = [NSMutableArray arrayWithCapacity:items.count];
        for (NSDictionary *dic in items.objectEnumerator) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSString *pString = dic[@"p"];
                NSString *mString = dic[@"m"];
                ABViewSource *barrageSource = [ABViewSource createWithP:pString M:mString];
                ABBaseModel *barrage = [ABFactory createBarrageWithBarrageSource:barrageSource
                                                                             configuration:self.configuration];
                if (barrage) {
                    [barrages addObject:barrage];
                }
            }
        }
        
        [barrages sortUsingComparator:^NSComparisonResult(ABBaseModel *obj1, ABBaseModel *obj2) {
            return obj1.time<obj2.time?NSOrderedAscending:NSOrderedDescending;
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.barrages = barrages;
            self.isPrepared = YES;
            self.isPreFilter = YES;
            if ([self.delegate respondsToSelector:@selector(arcaneBarrageViewPerpareComplete:)]) {
                [self.delegate arcaneBarrageViewPerpareComplete:self];
            }
        });
    });
}


- (void)start
{
    if (!self.delegate) {
        return;
    }
    [self resume];
}
- (void)pause
{
    BOOL isBuffering = [self.delegate arcaneBarrageViewIsBuffering:self];
    if (!self.isPlaying || isBuffering) {
        return;
    }
    self.isPlaying = NO;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self.renderer pauseRenderer];
}
- (void)resume
{
    if (self.isPlaying || !self.isPrepared) {
        return;
    }
    self.isPlaying = YES;
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:_frameInterval target:self selector:@selector(onTimeCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}
- (void)stop
{
    self.isPlaying = NO;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self.renderer stopRenderer];
}

- (void)sendArcaneBarrageSource:(ABViewSource *)source
{
    __block ABBaseModel *sendBarrage = [ABFactory createBarrageWithBarrageSource:source
                                                                             configuration:self.configuration];
    if (!sendBarrage) {
        return;
    }
    
    sendBarrage.isSelfID = self.configuration.isShowLineWhenSelf;
    
    __block NSMutableArray *newBarrages = [NSMutableArray arrayWithArray:self.barrages];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ABBaseModel *lastBarrage = newBarrages.lastObject;
        if (newBarrages.count<1 || sendBarrage.time>lastBarrage.time) {
            [newBarrages addObject:sendBarrage];
        } else {
            ABBaseModel *tempDanmaku = nil;
            for (NSInteger index=0; index<newBarrages.count; index++) {
                tempDanmaku = newBarrages[index];
                if (sendBarrage.time<tempDanmaku.time) {
                    [newBarrages insertObject:sendBarrage atIndex:index];
                    break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.barrages = newBarrages;
            self.isPreFilter = YES;
        });
    });
}

#pragma mark - Draw
- (void)onTimeCount
{
    float playTime = [self.delegate arcaneBarrageViewGetPlayTime:self];
    if (playTime<=0) {
        return;
    }
    
    float interval = playTime-_barrageTime.time;
    _barrageTime.time = playTime;
    _barrageTime.interval = _frameInterval;
    
    if (self.isPreFilter || interval<0 || interval>ArcaneBarrageFilterInterval) {
        self.isPreFilter = NO;
        self.curBarrages = [self.filter filterBarrages:self.barrages time:_barrageTime];
    }
    
    BOOL isBuffering = [self.delegate arcaneBarrageViewIsBuffering:self];
    [self.renderer drawBarrages:self.curBarrages time:_barrageTime isBuffering:isBuffering];
    
    _timeCount+=_frameInterval;
    if (_timeCount>ArcaneBarrageFilterInterval) {
        _timeCount = 0;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *filterArray = [self.filter filterBarrages:self.barrages time:_barrageTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.curBarrages = filterArray;
            });
        });
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}

@end
