//
//  ViewController.m
//  demoGuidePagesIOS
//
//  Created by WoodGao on 15/11/23.
//  Copyright © 2015年 wood. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
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
    
    view=[[GuidePagesIOS alloc]initWithFrame:self.view.bounds views:viewsArray isPageControlHidden:YES isLoopPlay:YES];
 
    view.loopDelayTime=3.0;
    view.delegate=self;
    
    [self.view addSubview:view];
    [view loopPlay:YES];
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
