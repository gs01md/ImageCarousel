//
//  GuidePagesIOS.m
//  demoGuidePagesIOS
//
//  Created by WoodGao on 15/11/25.
//  Copyright © 2015年 wood. All rights reserved.
//

#import "GuidePagesIOS.h"

@interface GuidePagesIOS() {
    UIView *firstPage;
    UIView *middlePage;
    UIView *lastPage;
    
    NSTimer *loopPlayTimer;
    UIGestureRecognizer *clickGesture;
}


@property (nonatomic,readonly)  UIScrollView *scrollView;
@property (nonatomic,readonly)  UIPageControl *pageControl;
@property (nonatomic,assign)    NSInteger currentPage;
@property (nonatomic,strong)    NSMutableArray *viewsArray;


@end

@implementation GuidePagesIOS

- (id)initWithFrame:(CGRect)frame views:(NSMutableArray*)views isPageControlHidden:(BOOL)isHidden isLoopPlay:(BOOL)isLoop{
    self = [super initWithFrame:frame];
    if (self) {
        
        //手势
        clickGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
        
        //滚动视图
        //Frame 同当前视图大小
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        
        //三倍宽度，当前页，前一页，后一页
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [_scrollView addGestureRecognizer:clickGesture];
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        
        //设置分页控件的位置和大小
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidden = isHidden;
        
        [self addSubview:_pageControl];
        
        [self setViewsArray:views];
        
    }
    return self;
}

/**
 *  启动或停止定时器：自动显示下一个图片
 *
 *  @param shouldStart
 */
-(void)loopPlay:(BOOL)willPlay{
    if (willPlay) {
        if (![loopPlayTimer isValid]) {
            
            loopPlayTimer=[NSTimer scheduledTimerWithTimeInterval:_loopDelayTime target:self selector:@selector(loopPlayNext) userInfo:nil repeats:YES];
        }
        
    }else if ([loopPlayTimer isValid]) {
        [loopPlayTimer invalidate];
        loopPlayTimer = nil;
    }
}

-(void)loopPlayNext {
    if (_currentPage+1>=[_viewsArray count]) {
        _currentPage=0;
    }
    else
        _currentPage++;
    
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width*2, 0) animated:YES];
}

-(void)reloadData {
    [firstPage removeFromSuperview];
    [middlePage removeFromSuperview];
    [lastPage removeFromSuperview];
    
    if (_currentPage==0) {
        firstPage=[_viewsArray lastObject];
        middlePage=[_viewsArray objectAtIndex:_currentPage];
        lastPage=[_viewsArray objectAtIndex:_currentPage+1];
    }else if (_currentPage==[_viewsArray count]-1){
        firstPage=[_viewsArray objectAtIndex:_currentPage-1];
        middlePage=[_viewsArray objectAtIndex:_currentPage];
        lastPage=[_viewsArray objectAtIndex:0];
    }else {
        firstPage=[_viewsArray objectAtIndex:_currentPage-1];
        middlePage=[_viewsArray objectAtIndex:_currentPage];
        lastPage=[_viewsArray objectAtIndex:_currentPage+1];
    }
    
    [_pageControl setCurrentPage:_currentPage];
    
    
    CGSize scrollSize=_scrollView.bounds.size;
    [firstPage setFrame:CGRectMake(0, 0, scrollSize.width, scrollSize.height)];
    [middlePage setFrame:CGRectMake(scrollSize.width, 0, scrollSize.width, scrollSize.height)];
    [lastPage setFrame:CGRectMake(scrollSize.width*2, 0, scrollSize.width, scrollSize.height)];
    [_scrollView addSubview:firstPage];
    [_scrollView addSubview:middlePage];
    [_scrollView addSubview:lastPage];
    
    //自动timer滑行后自动替换，不再动画
    //移动到中间页，然后再做动画到最后一页
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
}


#pragma mark Setter

-(void)setViewsArray:(NSMutableArray *)viewsArray {
    if (viewsArray && viewsArray.count > 1) {
        _pageControl.numberOfPages=[viewsArray count];
        _viewsArray=viewsArray;
        _currentPage=0;
        [_pageControl setCurrentPage:_currentPage];
    }
    [self reloadData];
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //自动timer滑行后自动替换，不再动画
    [self reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //手动滑动自动替换，悬停timer
    [loopPlayTimer invalidate];
    loopPlayTimer=nil;
    loopPlayTimer=[NSTimer scheduledTimerWithTimeInterval:_loopDelayTime target:self selector:@selector(loopPlayNext) userInfo:nil repeats:YES];
    int x = scrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        if (_currentPage+1==[_viewsArray count]) {
            _currentPage=0;
        }else
            _currentPage++;
    }
    
    //往上翻
    if(x <= 0) {
        if (_currentPage-1<0) {
            _currentPage=[_viewsArray count]-1;
        }else
            _currentPage--;
    }
    
    [self reloadData];
    
}


#pragma protocol

- (void)handleGesture:(UITapGestureRecognizer *)clickGesture {
    //如果有该接口，则调用该接口
    if ([_delegate respondsToSelector:@selector(clickPage:atIndex:)]) {
        [_delegate clickPage:self atIndex:_currentPage];
    }
    
}

@end

