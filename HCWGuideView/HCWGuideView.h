//
//  HCWGuideView.h
//  Example
//
//  Created by HCW on 16/8/31.
//  Copyright © 2016年 HCW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCWGuideView : UIView
@property (nonatomic, strong) UIColor *pageControlCurrentColor; /**< 指示器选中颜色 默认greenColor */
@property (nonatomic, strong) UIColor *pageControlNomalColor;   /**< 指示器颜色 默认whiteColor */
@property (nonatomic, assign) BOOL pageControlHidden;           /**< 指示器隐藏 默认NO */
@property (nonatomic, assign) BOOL enterButtonHidden;           /**< 进入按钮隐藏 默认NO 如果隐藏就在最后一页左滑进入 */

+ (instancetype)showGuideViewWithImages:(NSArray<NSString *> *)imageNames;

@end
