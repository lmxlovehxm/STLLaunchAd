//
//  STLLaunchAdView.m
//  STLLaunchAd
//
//  Created by LiMingXing on 2018/3/20.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "STLLaunchAdView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface STLLaunchAdView()

@property (strong, nonatomic) STLLaunchItemModel *model;
// 定时器
@property(nonatomic,strong)NSTimer *timer;
// 剩余多长时间(到计时)
@property(nonatomic,assign)NSInteger lastTime;
// 设计的本地和网络图片
@property(nonatomic,strong)UIImageView *imageView;
// 倒计时跳过的Button
@property(nonatomic,strong)UIButton *skipBtn;
// 视频播放器（视频播放专用）
@property(nonatomic,strong)MPMoviePlayerController *player;

@end

@implementation STLLaunchAdView

- (instancetype)initWithModel:(STLLaunchItemModel *)model{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = [UIScreen mainScreen].bounds;
        self.model = model;
        self.lastTime = self.model.launchAdTime;
    }
    return self;
}

#pragma mark ---------------展示和消失-------------------

- (void)show{
    switch (self.model.launchType) {
        case LaunchTypeLocal:
        {
            [self createLocalImages];
        }
            break;
        case LaunchTypeUrl:
        {
            [self createNetStaticImages];
        }
            break;
        case LaunchTypeGIFUrl:
        {
            [self createNetGIFImages];
        }
            break;
        case LaunchTypeVideoLocal:
        {
            [self creatLocalVideos];
        }
            break;
        case LaunchTypeVideoNet:
        {
            [self creatLocalVideos];
        }
            break;
        default:
            break;
    }
    [self addSubview:self.skipBtn];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss{
    [UIView animateWithDuration:0.6f animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.5,1.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ---------------业务-------------------

//创建本地图片
- (void)createLocalImages{
    if (self.model.launchUrl.length) {
        self.imageView.image = [UIImage imageWithContentsOfFile:self.model.launchUrl];
        if (self.model.launchAdTime) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.model.launchAdTime target:self selector:@selector(continueTimer:) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
            [self addSubview:self.imageView];
        }
    }
}
//创建网络图片
- (void)createNetStaticImages{
    if (self.model.launchUrl.length) {
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.launchUrl]];
        if (self.model.launchAdTime) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(continueTimer:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
            [self addSubview:self.imageView];
        }
    }
}
//创建网络GIF图片
- (void)createNetGIFImages{
    if (self.model.launchUrl.length) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.launchUrl]];
        self.imageView.image = [UIImage sd_animatedGIFWithData:data];
        if (self.model.launchAdTime) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(continueTimer:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
            [self addSubview:self.imageView];
        }
    }
}


// 加载视频
-(void)creatLocalVideos {
    if (self.model.launchUrl.length) {
        // 本地视频播放用 fileURLWithPath转换url切记，就爬了这个坑
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:[self giveUserUrl]];
        [self addSubview:self.player.view];
        self.player.shouldAutoplay = YES;
        [self.player setControlStyle:MPMovieControlStyleNone];
        self.player.repeatMode = MPMovieRepeatModeNone;
        
        self.player.view.frame =[UIScreen mainScreen].bounds;
        
        self.player.view.alpha = 0;
        // 视频的转换
        [UIView animateWithDuration:3 animations:^{
            self.player.view.alpha = 1;
            [self.player prepareToPlay];
        }];
        
        // 添加播放完毕之后的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
    
}

-(NSURL *)giveUserUrl {
    return self.model.launchType == LaunchTypeVideoNet ?[NSURL URLWithString:self.model.launchUrl]:[NSURL fileURLWithPath:self.model.launchUrl];
}


#pragma mark ---------------定时器相关-------------------

// 定时器的运行
-(void)continueTimer:(NSTimer *)timer {
    self.lastTime--;
    NSLog(@"点我");
    if(self.lastTime < 0){
        [self removeTimer:timer];
    }
    NSString *skipTitles;
    if (self.lastTime == 0) {
        skipTitles = @"跳过";
    }else{
        skipTitles = [NSString stringWithFormat:@"跳过 %lds",self.lastTime];
    }
    [self.skipBtn setTitle:skipTitles forState:UIControlStateNormal];
}

-(void)removeTimer:(NSTimer *)timer {
    [self.timer invalidate];
    self.timer =nil;
    [self dismiss];
}

#pragma mark - NSNotificationCenter
//播放完成处理
- (void)videoPlayFinish
{
    MPMoviePlaybackState playbackState = [self.player playbackState];
    if (playbackState == MPMoviePlaybackStateStopped || playbackState == MPMoviePlaybackStatePaused) {
        [self.player play];
    }
}


#pragma mark ---------------Method-------------------
//点击跳过按钮
-(void)skipBtnClick:(UIButton *)button {
    if (self.model.launchType == LaunchTypeVideoNet || self.model.launchType == LaunchTypeVideoLocal) {
        [self.player stop];
        self.player =nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [self removeTimer:nil];
}


#pragma mark ---------------实例-------------------

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _imageView;
}

- (UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.frame = CGRectMake(self.frame.size.width - 90, 20, 80, 30);
        _skipBtn.layer.masksToBounds = YES;
        _skipBtn.layer.cornerRadius = 5;
        _skipBtn.backgroundColor = [UIColor colorWithRed:125/256.0 green:125/256.0  blue:125/256.0  alpha:0.5];
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    }
    return _skipBtn;
}


@end
