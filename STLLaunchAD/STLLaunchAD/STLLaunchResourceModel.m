//
//  STLLaunchResourceModel.m
//  STLLaunchAd
//
//  Created by LiMingXing on 2018/3/20.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "STLLaunchResourceModel.h"

NSString *const fileName = @"launchResourceModel";//文件路径
NSString *const fileMoment = @".launchResource";//文件名字
@implementation STLLaunchResourceModel

//创建数据存储路径(放在缓存文件里)
+ (NSString *)createLanchResourcePath{
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    NSString * path = [NSString stringWithFormat:@"%@/%@",cachePath,fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if  (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {//先判断目录是否存在，不存在才创建
        BOOL res =[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            return path;
        }else{
            return nil;
        }
    }
    return [path stringByAppendingPathComponent:fileMoment];
    
}

//写入model到路径
+ (void)writeModel:(STLLaunchItemModel *)model{
    //归档
    [NSKeyedArchiver archiveRootObject:model toFile:[self createLanchResourcePath]];
}
//读取缓存中model
+ (STLLaunchItemModel *)readModel{
    STLLaunchItemModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:[self createLanchResourcePath]];
    return model;
}
//清除文件
+ (BOOL)deleteLaunchModel{
    BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:[self createLanchResourcePath] error:nil];
    return ret;
}

+ (BOOL)isAdResourceExis{
    return [self readModel];
}

@end
