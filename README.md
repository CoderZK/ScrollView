# ScrollView
一个小巧实用的实现轮播图的小框架
# 播放网络图片初始化

```objc
 self.scrollView = [[CarouselView alloc] initWithFrame:CGRectMake(0, 0, 375, 288) imageURLS:[URLs 数组]];
[self.view addSubview:self.scrollView];

```

# 播放本地图片初始化
```objc
self.scrollView = [[CarouselView alloc] initWithFrame:CGRectMake(0, 300, 375, 288) localImages:[本地图片名数组]];
[self.view addSubview:self.scrollView];

```
# 点击图片实现的方法
```objc

self.scrollView2.imageClickBlock =^(NSInteger index){
NSLog(@"点击了%ld张",index);
};

```