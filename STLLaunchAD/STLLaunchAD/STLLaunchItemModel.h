//
//  STLLaunchItemModel.h
//  STLLaunchAd
//
//  Created by LiMingXing on 2018/3/20.
//  Copyright © 2018年 李明星. All rights reserved.
//  广告参数

#import <Foundation/Foundation.h>


typedef enum:NSInteger {
    LaunchTypeLocal,//本地图片（静态）
    LaunchTypeVideoLocal,//本地视频
    LaunchTypeVideoNet,//网络视频
    LaunchTypeUrl,//网络图片静态
    LaunchTypeGIFUrl//网络gif
}LaunchType;

@interface STLLaunchItemModel : NSObject

@property (assign, nonatomic) LaunchType launchType;//广告页类型
@property (copy, nonatomic) NSString *detailUrl;//点击广告详情页
@property (assign, nonatomic) int launchAdTime;//广告等待时间,默认不显示，设置就显示
@property (copy, nonatomic) NSString *launchUrl;

@end
