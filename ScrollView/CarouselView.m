//
//  CarouselView.m
//  leiSure
//
//  Created by ZK on 15/6/17.
//  Copyright © 2015年 ZK. All rights reserved.
//

#import "CarouselView.h"
#import <UIImageView+WebCache.h>


@interface CarouselView ()<UIScrollViewDelegate>

//最底层的ScrollView
@property (nonatomic,strong) UIScrollView *scrollerView;
//位置指示器
@property (nonatomic,strong) UIPageControl *pageController;
//图片网址数组
//@property (nonatomic,strong) NSArray *images;

//定时器
@property (nonatomic,strong) NSTimer *timer;


@end

@implementation CarouselView

- (instancetype)initWithFrame:(CGRect)frame imageURLS:(NSArray *)imageURLS{
    self = [super initWithFrame:frame];
    if (self) {
        //如果数组里是空的 就没有必要初始化了
        if (imageURLS.count == 0) {
            return nil;
        }
        //初始化ScrollView 
        self.scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //指定代理对象
        self.scrollerView.delegate = self;
        //不显示水平进度条
        self.scrollerView.showsHorizontalScrollIndicator = NO;

        self.scrollerView.backgroundColor = [UIColor cyanColor];
        //整页滑动
        self.scrollerView.pagingEnabled = YES;
        [self addSubview:self.scrollerView];

        //初始化PageController
        self.pageController = [[UIPageControl alloc] initWithFrame:(CGRectMake(0, frame.size.height - 20, frame.size.width, 20))];
        [self addSubview:self.pageController];

        //配置scrollerView
        [self setUpScrollerView:imageURLS];

        //添加点击事件
        [self.pageController addTarget:self action:@selector(pageControllerClick) forControlEvents:(UIControlEventValueChanged)];

        if (imageURLS.count > 1) {
            //初始化定时器
            self.timer = [NSTimer scheduledTimerWithTimeInterval:Kinterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }

    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame localImages:(NSArray *)localImages {
    self = [super initWithFrame:frame];
    if (localImages.count == 0) {
        return nil;
    }
    //初始化ScrollView
    self.scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //指定代理对象
    self.scrollerView.delegate = self;
    //不显示水平进度条
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    
    self.scrollerView.backgroundColor = [UIColor cyanColor];
    //整页滑动
    self.scrollerView.pagingEnabled = YES;
    [self addSubview:self.scrollerView];
    
    //初始化PageController
    self.pageController = [[UIPageControl alloc] initWithFrame:(CGRectMake(0, frame.size.height - 20, frame.size.width, 20))];
    [self addSubview:self.pageController];
    
    //配置scrollerView
    [self setUpScrollerViewWith:localImages];

    //添加点击事件
    [self.pageController addTarget:self action:@selector(pageControllerClick) forControlEvents:(UIControlEventValueChanged)];
    
    if (localImages.count > 1) {
        //初始化定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:Kinterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }

    
    return self;
}


- (void)setUpScrollerViewWith:(NSArray *)localImages {
    //如果只有一张 就不用轮播
    if (localImages.count == 1) {
        self.scrollerView.contentSize = self.scrollerView.frame.size;
        UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))];
        image.image = [UIImage imageNamed:localImages[0]];
        [self.scrollerView addSubview:image];
        image.userInteractionEnabled = YES;
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickFouncation)];
        [image addGestureRecognizer:tap];
        [self.timer setFireDate:[NSDate distantFuture]];
        return;

    }
    
    //设置滚动区域
    self.scrollerView.contentSize = CGSizeMake(self.frame.size.width * (localImages.count + 2), 0);
    
    //从第一张真图开始显示
    self.scrollerView.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    for (int i = 0; i < localImages.count + 2; i++) {
        //创建UIimageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))];
        
        //创建点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickFouncation)];
        [imageView addGestureRecognizer:tap];
        //打开交互
        imageView.userInteractionEnabled = YES;
        
        //第一张假图显示真实的最后一张
        if (i == 0) {
            NSString * lastStr = [localImages lastObject];
            [imageView setImage:[UIImage imageNamed:lastStr]];
            //最后一张假图显示第一张真图
        }else if (i == localImages.count + 1){
            NSString * firstStr = [localImages firstObject];
            [imageView setImage:[UIImage imageNamed:firstStr]];
        }else{
            //显示网络图片
            [imageView setImage:[UIImage imageNamed:localImages[i - 1]]];
        }
        
        [self.scrollerView addSubview:imageView];
    }
    //设置PageController个数
    self.pageController.numberOfPages = localImages.count;
    
}



//重新配置轮播图数据
- (void)setUpScrollerView:(NSArray *)imageURLS{

    //如果只有一张 就不用轮播
    if (imageURLS.count == 1) {
        self.scrollerView.contentSize = self.scrollerView.frame.size;

        UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))];
        
        
        
        [image sd_setImageWithURL:[NSURL URLWithString:imageURLS.lastObject]];
        [self.scrollerView addSubview:image];
        image.userInteractionEnabled = YES;
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickFouncation)];
        [image addGestureRecognizer:tap];
        [self.timer setFireDate:[NSDate distantFuture]];
        return;
    }


    //设置滚动区域
    self.scrollerView.contentSize = CGSizeMake(self.frame.size.width * (imageURLS.count + 2), 0);
    //从第一张真图开始显示
    self.scrollerView.contentOffset = CGPointMake(self.frame.size.width, 0);

    for (int i = 0; i < imageURLS.count + 2; i++) {
        //创建UIimageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))];

        //创建点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickFouncation)];
        [imageView addGestureRecognizer:tap];
        //打开交互
        imageView.userInteractionEnabled = YES;

        //第一张假图显示真实的最后一张
        if (i == 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLS.lastObject]];
            //最后一张假图显示第一张真图
        }else if (i == imageURLS.count + 1){
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLS.firstObject]];
        }else{
            //显示网络图片
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLS[i - 1]]];
        }

        [self.scrollerView addSubview:imageView];
    }
    //设置PageController个数
    self.pageController.numberOfPages = imageURLS.count;
}

//正在滚动时  无论是修改了偏移量 还是用户滑动都会执行
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滚动到最前面时回到真实的最后一张
    if (scrollView.contentOffset.x <= 0) {
        self.scrollerView.contentOffset = CGPointMake(self.frame.size.width * self.pageController.numberOfPages , 0);
    }
    //滚动到最后一张假图的时候 回到第一张真图
    if (scrollView.contentOffset.x >= (self.pageController.numberOfPages + 1) * self.frame.size.width) {
        self.scrollerView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    //修改page下标
    self.pageController.currentPage = self.scrollerView.contentOffset.x / self.frame.size.width - 1;
}
//用户拖拽时
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //暂停定时器 定时器没有暂停的方法 只能设置 开启时间
    [self.timer setFireDate:[NSDate distantFuture]];
}

//结束拖拽时在开启定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:Kinterval]];

}

- (void)timerAction{
    NSInteger index = self.scrollerView.contentOffset.x / self.frame.size.width + 1;


    //当结构体和对象连用时 不能直接赋值
    CGPoint offset = self.scrollerView.contentOffset;
    offset.x = self.frame.size.width * index;

    //修改偏移量
    [self.scrollerView setContentOffset:offset animated:YES];
}

//pageController点击方法
- (void)pageControllerClick{

    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollerView.contentOffset = CGPointMake((self.pageController.currentPage + 1) * self.frame.size.width, 0);

    }completion:^(BOOL finished) {
        //继续定时器
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:Kinterval]];
    }];
}

//图片点击方法
- (void)imageClickFouncation{
    //计算当前显示的图片
    NSInteger index = self.scrollerView.contentOffset.x / self.frame.size.width;
    //先判断block是否实现
    if (self.imageClickBlock) {

        if (self.scrollerView.contentSize.width == self.frame.size.width) {
            self.imageClickBlock(index);
        }else{
            self.imageClickBlock(index - 1);
        }
    }
}



@end
