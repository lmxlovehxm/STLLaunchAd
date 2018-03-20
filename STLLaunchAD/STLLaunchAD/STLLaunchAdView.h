//
//  STLLaunchAdView.h
//  STLLaunchAd
//
//  Created by LiMingXing on 2018/3/20.
//  Copyright © 2018年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STLLaunchItemModel.h"

@interface STLLaunchAdView : UIView

- (instancetype)initWithModel:(STLLaunchItemModel *)model;

- (void)show;

- (void)dismiss;

@end
