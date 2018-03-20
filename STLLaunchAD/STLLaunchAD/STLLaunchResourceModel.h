//
//  STLLaunchResourceModel.h
//  STLLaunchAd
//
//  Created by LiMingXing on 2018/3/20.
//  Copyright © 2018年 李明星. All rights reserved.
// 管理广告资源

#import <Foundation/Foundation.h>
#import "STLLaunchItemModel.h"

@interface STLLaunchResourceModel : NSObject

/** 是否存在缓存文件*/
+ (BOOL)isAdResourceExis;
//写入文件
+ (void)writeModel:(STLLaunchItemModel *)model;
//读取文件
+ (STLLaunchItemModel *)readModel;
//清除文件
+ (BOOL)deleteLaunchModel;
@end
