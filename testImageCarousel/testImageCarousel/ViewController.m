//
//  ViewController.m
//  testImageCarousel
//
//  Created by Simon on 16/5/3.
//  Copyright © 2016年 gaoshuai. All rights reserved.
//

#import "ViewController.h"
#import <ImageCarousel/ImageCarouselMainHead.h>

@interface ViewController ()<GastureScrollViewDelegate>{
    ImageCarouselWood *view;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.png"]];
    UIImageView *imageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2.png"]];
    UIImageView *imageView3=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3.png"]];
    
    NSMutableArray *viewsArray=[[NSMutableArray alloc]initWithObjects:imageView1,nil];
    
    view=[[ImageCarouselWood alloc]initWithFrame:self.view.bounds views:viewsArray isPageControlHidden:NO isLoopPlay:NO];
    
    view.m_loopDelayTime = 3.0;
    view.delegate = self;
    
    [self.view addSubview:view];
}

//本视图消失时，停止动画
-(void)viewDidDisappear:(BOOL)animated
{
    [view loopPlay:NO];
    
}

//点击事件
- (void)didClickPage:(ImageCarouselWood *)view atIndex:(NSInteger)index
{
    //do something
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
