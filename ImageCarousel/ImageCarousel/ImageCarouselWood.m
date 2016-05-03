//
//  GuidePagesIOS.m
//  demoGuidePagesIOS
//
//  Created by WoodGao on 15/11/25.
//  Copyright © 2015年 wood. All rights reserved.
//

#import "ImageCarouselWood.h"

@interface ImageCarouselWood() {
    
    /**
     *  前一页
     */
    UIView *m_firstPage;
    
    /**
     *  当前页
     */
    UIView *m_middlePage;
    
    /**
     *  下一页
     */
    UIView *m_lastPage;
    
    /**
     *  自动轮播视图
     */
    NSTimer *m_loopPlayTimer;
    
    /**
     *  点击视图时的事件
     */
    UIGestureRecognizer *m_clickGesture;
    
    /**
     *  主视图
     */
    UIScrollView *m_scrollView;
    
    /**
     *  分页控件
     */
    UIPageControl *m_pageControl;
    
    /**
     *  当前页号
     */
    NSInteger m_currentPage;
}

/**
 *  保存图片视图
 */
@property (nonatomic,strong)    NSMutableArray *viewsArray;



@end

@implementation ImageCarouselWood
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
- (id)initWithFrame:(CGRect)frame views:(NSMutableArray*)views isPageControlHidden:(BOOL)isHidden isLoopPlay:(BOOL)isLoop{
    
    self = [super initWithFrame:frame];
    
    if (self) {

        [self uiScrollView];
        
        [self uiPageInfo:isHidden];
        
        [self setViewsArray:views];
        
        [self gestureScrollView];
        
    }
    
    return self;
}

/**
 *  创建滚动视图
 */
- (void) uiScrollView {
    
    //滚动视图
    //Frame 同当前视图大小
    m_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    m_scrollView.delegate = self;
    
    //三倍宽度，当前页，前一页，后一页
    m_scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    m_scrollView.showsHorizontalScrollIndicator = NO;
    m_scrollView.pagingEnabled = YES;
    
    
    [self addSubview:m_scrollView];
}

/**
 *  分页控件
 *
 *  @param isHidden
 */
- (void) uiPageInfo:(BOOL) isHidden{
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    
    //设置分页控件的位置和大小
    m_pageControl = [[UIPageControl alloc] initWithFrame:rect];
    m_pageControl.userInteractionEnabled = NO;
    m_pageControl.hidden = isHidden;
    
    [self addSubview:m_pageControl];
}

/**
 *  添加手势
 */
- (void) gestureScrollView {
    
    //手势
    m_clickGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    
    
    if (!m_scrollView) {
        
        [self uiScrollView];
    }
    
    [m_scrollView addGestureRecognizer:m_clickGesture];
}

#pragma mark - 功能
/**
 *  启动或停止定时器：自动显示下一个图片
 */
-(void)loopPlay: (BOOL)willPlay{
    
    if (willPlay) {
        
        if (![m_loopPlayTimer isValid]) {
            
            m_loopPlayTimer=[NSTimer scheduledTimerWithTimeInterval:self.m_loopDelayTime target:self selector:@selector(loopPlayNext) userInfo:nil repeats:YES];
        }
        
    }else if ([m_loopPlayTimer isValid]) {
        
        [m_loopPlayTimer invalidate];
        m_loopPlayTimer = nil;
    }
}

/**
 *  一直是从第一个跳到第二个页面
 *  改变的是每个页面的内容
 */
-(void)loopPlayNext {
    
    int iCount = 0;
    
    if (_viewsArray) {
        
        iCount = _viewsArray.count;
    }
    
    switch (iCount) {
            
        case 0:
            
            
            break;
            
        case 1:
            
            [self loopPlayNextOne];
            
            break;
            
        default:
            
            [self loopPlayNextNormal];
            
            break;
    }
    

}

-(void) loopPlayNextOne {
    
    if ([m_loopPlayTimer isValid]) {
        
        [m_loopPlayTimer invalidate];
        m_loopPlayTimer = nil;
    }
    
}

-(void)loopPlayNextNormal {
    
    if (m_currentPage+1 >= [_viewsArray count]) {
        m_currentPage=0;
    }
    else
        m_currentPage++;
    
    [m_scrollView setContentOffset:CGPointMake(self.bounds.size.width*2, 0) animated:YES];
}

/**
 *  滑动动作完成时，调整各个页面中的视图
 */
-(void)reloadData {
    
    int iCount = 0;
    
    if (_viewsArray) {
        
        iCount = _viewsArray.count;
    }
    
    switch (iCount) {
            
        case 0:
            
            
            break;
            
        case 1:
            
            [self reloadDataOne];
            
            break;
            
        default:
            
            [self reloadDataNormal];
            
            break;
    }

    
}

/**
 *  图片数量为1时
 */
-(void)reloadDataOne{
    
    if (!m_firstPage) {
        
        [m_pageControl setCurrentPage:m_currentPage];
        
        m_firstPage  =  [_viewsArray lastObject];
        
        CGSize scrollSize = m_scrollView.bounds.size;
        [m_firstPage setFrame:CGRectMake(0, 0, scrollSize.width, scrollSize.height)];
        [m_scrollView addSubview:m_firstPage];
        
        [m_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        
        m_scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    }

}

/**
 *  图片数量大于等于2时
 */
-(void)reloadDataNormal {
    
    [m_pageControl setCurrentPage:m_currentPage];
    
    /**
     *  先移除
     */
    [m_firstPage removeFromSuperview];
    [m_middlePage removeFromSuperview];
    [m_lastPage removeFromSuperview];
    
    
    /**
     *  然后重新设置每个页的图片视图
     */
    if (m_currentPage==0) {
        
        m_firstPage  =  [_viewsArray lastObject];
        m_middlePage =  [_viewsArray objectAtIndex:m_currentPage];
        m_lastPage   =  [_viewsArray objectAtIndex:m_currentPage+1];
        
    }else if (m_currentPage==[_viewsArray count]-1){
        
        m_firstPage  =  [_viewsArray objectAtIndex:m_currentPage-1];
        m_middlePage =  [_viewsArray objectAtIndex:m_currentPage];
        m_lastPage   =  [_viewsArray objectAtIndex:0];
        
    }else {
        
        m_firstPage  =  [_viewsArray objectAtIndex:m_currentPage-1];
        m_middlePage =  [_viewsArray objectAtIndex:m_currentPage];
        m_lastPage   =  [_viewsArray objectAtIndex:m_currentPage+1];
    }
    
    /**
     *  设置好各个页面的位置
     */
    CGSize scrollSize = m_scrollView.bounds.size;
    [m_firstPage setFrame:CGRectMake(0, 0, scrollSize.width, scrollSize.height)];
    [m_middlePage setFrame:CGRectMake(scrollSize.width, 0, scrollSize.width, scrollSize.height)];
    [m_lastPage setFrame:CGRectMake(scrollSize.width*2, 0, scrollSize.width, scrollSize.height)];
    
    /**
     *  最后再添加到ScrollView
     */
    [m_scrollView addSubview:m_firstPage];
    [m_scrollView addSubview:m_middlePage];
    [m_scrollView addSubview:m_lastPage];
    
    
    /**
     *  自动timer滑行后自动替换，不再动画
     *  移动到中间页，然后再做动画到最后一页
     */
    [m_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
}

#pragma mark - 滑动完成之后，重新设置视图在数组中的顺序

-(void)setViewsArray:(NSMutableArray *)viewsArray {
    
    if (viewsArray && viewsArray.count > 0) {
        
        _viewsArray  = viewsArray;
        
        m_pageControl.numberOfPages = [viewsArray count];
        m_currentPage = 0;
        
        [m_pageControl setCurrentPage:m_currentPage];
    }
    
    [self reloadData];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    //自动timer滑行后自动替换，不再动画
    [self reloadData];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //手动滑动自动替换，悬停timer
    [m_loopPlayTimer invalidate];
    m_loopPlayTimer=nil;
    m_loopPlayTimer=[NSTimer scheduledTimerWithTimeInterval:self.m_loopDelayTime target:self selector:@selector(loopPlayNext) userInfo:nil repeats:YES];
    int x = scrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        if (m_currentPage+1==[_viewsArray count]) {
            m_currentPage=0;
        }else
            m_currentPage++;
    }
    
    //往上翻
    if(x <= 0) {
        if (m_currentPage-1<0) {
            m_currentPage=[_viewsArray count]-1;
        }else
            m_currentPage--;
    }
    
    [self reloadData];
    
}


#pragma protocol

- (void)handleGesture:(UITapGestureRecognizer *)clickGesture {
    
    //如果有该接口，则调用该接口
    if ([_delegate respondsToSelector:@selector(clickPage:atIndex:)]) {
        [_delegate clickPage:self atIndex:m_currentPage];
    }
    
}

@end

