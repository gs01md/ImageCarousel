//
//  GuidePagesIOS.h
//  demoGuidePagesIOS
//
//  一共三页，前一页、当前页、下一页
//
//  Created by WoodGao on 15/11/25.
//  Copyright © 2015年 wood. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GastureScrollViewDelegate;


@interface ImageCarouselWood : UIView<UIScrollViewDelegate>{
    
    __unsafe_unretained id <GastureScrollViewDelegate>  _delegate;
}

/**
 *  包含点击等事件
 */
@property (nonatomic,assign) id<GastureScrollViewDelegate> delegate;


/**
 *  切换视图的间隔 (秒)
 */
@property (nonatomic,assign)    NSTimeInterval    m_loopDelayTime;

/**
 *  初始化轮播视图控制器
 *
 *  @param frame    ：位置
 *  @param views    ：图片
 *  @param isHidden ：是否显示所在页指示标识
 *  @param isLoop   ：是否启动轮播
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray*)views isPageControlHidden:(BOOL)isHidden isLoopPlay:(BOOL)isLoop;


/**
 *  停止或开始轮播
 *
 *  @param willPlay
 */
-(void)loopPlay:(BOOL)willPlay;

@end


/**
 *  协议
 */
@protocol GastureScrollViewDelegate <NSObject>

@optional
/**
 *  点击时的事件
 *
 *  @param view  ：
 *  @param index ：
 */
-(void)clickPage:(ImageCarouselWood *)view atIndex:(NSInteger)index;

@end
