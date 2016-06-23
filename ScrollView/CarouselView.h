//
//  CarouselView.m
//  leiSure
//
//  Created by ZK on 15/6/17.
//  Copyright © 2015年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义一个block 无返回值 有参数
typedef void(^CarouselViewBlock)(NSInteger index);

//自动轮播时间
#define Kinterval  2

@interface CarouselView : UIView
/** 图片点击block*/
@property (nonatomic,copy) CarouselViewBlock imageClickBlock;

/** 两个必要参数 frame 和 图片地址*/
- (instancetype)initWithFrame:(CGRect)frame imageURLS:(NSArray *)imageURLS;
/** 两个必要参数 frame 和 图片地址*/
- (instancetype)initWithFrame:(CGRect)frame localImages:(NSArray *)localImages;

/** 重新配置轮播图数据*/
- (void)setUpScrollerView:(NSArray *)imageURLS;

/** 重新配置本地轮播图*/
- (void)setUpScrollerViewWith:(NSArray *)localImages;


@end
