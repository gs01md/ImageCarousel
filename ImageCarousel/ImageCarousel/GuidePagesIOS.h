//
//  GuidePagesIOS.h
//  demoGuidePagesIOS
//
//  Created by WoodGao on 15/11/25.
//  Copyright © 2015年 wood. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GastureScrollViewDelegate;


@interface GuidePagesIOS : UIView<UIScrollViewDelegate>{
    
    __unsafe_unretained id <GastureScrollViewDelegate>  _delegate;
}

@property (nonatomic,assign) id<GastureScrollViewDelegate> delegate;
@property (nonatomic,assign)    NSTimeInterval    loopDelayTime;

-(void)loopPlay:(BOOL)willPlay;//轮播停止或开始
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray*)views isPageControlHidden:(BOOL)isHidden isLoopPlay:(BOOL)isLoop;

@end



@protocol GastureScrollViewDelegate <NSObject>

@optional
-(void)clickPage:(GuidePagesIOS *)view atIndex:(NSInteger)index;

@end
