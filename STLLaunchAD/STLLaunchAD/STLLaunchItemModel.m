//
//  STLLaunchItemModel.m
//  STLLaunchAd
//
//  Created by LiMingXing on 2018/3/20.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import "STLLaunchItemModel.h"


@interface STLLaunchItemModel()<NSCoding>

@end

@implementation STLLaunchItemModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.launchType forKey:@"launchType"];
    [aCoder encodeInt:self.launchAdTime forKey:@"launchAdTime"];
    [aCoder encodeObject:self.detailUrl forKey:@"detailUrl"];
    [aCoder encodeObject:self.launchUrl forKey:@"launchUrl"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.launchUrl = [aDecoder decodeObjectForKey:@"launchUrl"];
        self.detailUrl = [aDecoder decodeObjectForKey:@"detailUrl"];
        self.launchAdTime = [aDecoder decodeIntForKey:@"launchAdTime"];
        self.launchType = [aDecoder decodeIntegerForKey:@"launchType"];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"广告地址：%@\n广告详情页：%@\n广告类型：%ld\n广告等待时间：%d",self.launchUrl, self.detailUrl, self.launchType, self.launchAdTime];
}

@end
