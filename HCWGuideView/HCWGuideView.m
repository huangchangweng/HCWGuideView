//
//  HCWGuideView.m
//  Example
//
//  Created by HCW on 16/8/31.
//  Copyright © 2016年 HCW. All rights reserved.
//

#import "HCWGuideView.h"

#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width
static NSString * const kAppVersion = @"appVersion";

@interface HCWGuideView() <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) NSArray *imageNames;
@end

@implementation HCWGuideView

#pragma mark - Life Cycle

- (instancetype)initWithImageNames:(NSArray<NSString*> *)imageNames
{
    if (self == [super initWithFrame:CGRectZero]) {
        self.imageNames = imageNames;
        [self build];
    }
    return self;
}

- (void)dealloc {
    [self unregisterFromKVO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 30);
}

#pragma mark - Private Method

- (void)build
{
    self.pageControlCurrentColor = [UIColor grayColor];
    self.pageControlNomalColor = [UIColor whiteColor];
    [self registerForKVO];
    
    if ([self isFirstLauch]) {
        UIView *view = [[UIApplication sharedApplication].delegate window].rootViewController.view;
        self.frame = view.bounds;
        [view addSubview:self];
        
        // scrollView
        self.frame = self.bounds;
        self.scrollView.contentSize = CGSizeMake(kScreenWidth*self.imageNames.count, kScreenHeight);
        [self addSubview:self.scrollView];
        for (int i=0; i<self.imageNames.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
            imageView.image = [UIImage imageNamed:self.imageNames[i]];
            [self.scrollView addSubview:imageView];
            if (i == self.imageNames.count - 1) {
                if (!self.enterButtonHidden) {
                    UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, kScreenHeight-40, 100, 30)];
                    enterButton.titleLabel.font = [UIFont systemFontOfSize:14];
                    [enterButton setTitle:@"点击进入" forState:0];
                    [enterButton setTitleColor:[UIColor blackColor] forState:0];
                    [enterButton addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
                    self.enterButton = enterButton;
                    [imageView addSubview:enterButton];
                    imageView.userInteractionEnabled = YES;
                }
            }
        }
        
        // pageControl
        self.pageControl.numberOfPages = self.imageNames.count;
        self.pageControl.pageIndicatorTintColor = self.pageControlNomalColor;
        self.pageControl.currentPageIndicatorTintColor = self.pageControlCurrentColor;
        [self addSubview:self.pageControl];
        
    } else {
        [self removeFromSuperview];
    }
}

-(BOOL)isFirstLauch
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    } else {
        return NO;
    }
}

-(void)hideGuidView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(BOOL)isScrolltoLeft:(UIScrollView *)scrollView
{
    return [scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0;
}

#pragma mark - Class Method

+ (instancetype)showGuideViewWithImages:(NSArray<NSString *> *)imageNames
{
    HCWGuideView *guideView = [[HCWGuideView alloc] initWithImageNames:imageNames];
    return guideView;
}

#pragma mark - Response Event

- (void)enterAction
{
    [self hideGuidView];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreenWidth/2)/kScreenWidth;
    if (cuttentIndex == self.imageNames.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (!self.enterButtonHidden) {
                return ;
            }
            [self hideGuidView];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreenWidth/2)/kScreenWidth;
    self.pageControl.currentPage = cuttentIndex;
}

#pragma mark - KVO

- (void)registerForKVO
{
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths
{
    return @[@"pageControlCurrentColor",
             @"pageControlNomalColor",
             @"pageControlHidden",
             @"enterButtonHidden"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"pageControlCurrentColor"]) {
        self.pageControl.currentPageIndicatorTintColor = self.pageControlCurrentColor;
    } else if ([keyPath isEqualToString:@"pageControlNomalColor"]) {
        self.pageControl.pageIndicatorTintColor = self.pageControlNomalColor;
    } else if ([keyPath isEqualToString:@"pageControlHidden"]) {
        self.pageControl.hidden = self.pageControlHidden;
    } else if ([keyPath isEqualToString:@"enterButtonHidden"]) {
        self.enterButton.hidden = self.enterButtonHidden;
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark - Getter

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPage = 0;
        _pageControl.defersCurrentPageDisplay = YES;
    }
    return _pageControl;
}

@end
