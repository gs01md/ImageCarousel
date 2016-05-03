//
//  ViewController.m
//  testImageCarousel
//
//  Created by Simon on 16/5/3.
//  Copyright © 2016年 gaoshuai. All rights reserved.
//

#import "ViewController.h"
#import <ImageCarousel/GuidePagesIOS.h>

@interface ViewController ()<GastureScrollViewDelegate>{
    GuidePagesIOS *view;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.png"]];
    UIImageView *imageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2.png"]];
    UIImageView *imageView3=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3.png"]];
    
    NSMutableArray *viewsArray=[[NSMutableArray alloc]initWithObjects:imageView1,imageView2,imageView3,nil];
    
    view=[[GuidePagesIOS alloc]initWithFrame:self.view.bounds views:viewsArray isPageControlHidden:NO isLoopPlay:NO];
    
    view.loopDelayTime=3.0;
    view.delegate=self;
    
    [self.view addSubview:view];
}

//本视图消失时，停止动画
-(void)viewDidDisappear:(BOOL)animated
{
    [view loopPlay:NO];
    
}

//点击事件
- (void)didClickPage:(GuidePagesIOS *)view atIndex:(NSInteger)index
{
    //do something
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
