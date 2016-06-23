//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by ZK on 16/6/23.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ViewController.h"
#import "CarouselView.h"

@interface ViewController ()


@property (nonatomic, strong) CarouselView *scrollView;

@property (nonatomic , strong)CarouselView * scrollView2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//播放网络图片 (有可能网址错误,你可以换成自己的网址)
    NSArray * arr2 = @[@"http://pkimg.image.alimmdn.com/upload/20160620/48e9791d3932ceeaa2eb40ec62d9d46c.JPG!300300",@"http://pkimg.image.alimmdn.com/upload/20160620/bc22b4491f0b5bbd324a5d9e60e89e67.JPG!300300",@"http://pkimg.image.alimmdn.com/upload/20160616/21e43ec42d912f195662e3b85117c80d.JPG!300300"];
    
    self.scrollView = [[CarouselView alloc] initWithFrame:CGRectMake(0, 0, 375, 288) imageURLS:arr2];
    
    [self.view addSubview:self.scrollView];
//点击图片的block方法
    self.scrollView.imageClickBlock = ^(NSInteger index){
        NSLog(@"点击了%ld张",index);
    };
    
    
//播放本地图片
    NSArray * arr = @[@"1",@"2",@"3"];
    self.scrollView2 = [[CarouselView alloc] initWithFrame:CGRectMake(0, 300, 375, 288) localImages:arr];
    [self.view addSubview:self.scrollView2];
    
//点击图片的block方法
    self.scrollView2.imageClickBlock =^(NSInteger index){
        NSLog(@"点击了%ld张",index);
    };
 
    
    

}

@end
