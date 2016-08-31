# HCWGuideView
App首次启动或更新版本用到的引导页

![image](https://github.com/huangchangweng/HCWGuideView/blob/master/HCWGuideView_1.gif)
![image](https://github.com/huangchangweng/HCWGuideView/blob/master/HCWGuideView_2.gif)

## 使用方法
在AppDelegate中写
1.默认样式
    [HCWGuideView showGuideViewWithImages:@[@"guide_1", @"guide_2", @"guide_3"]];
2.自定义样式
    HCWGuideView *guideView = [HCWGuideView showGuideViewWithImages:@[@"guide_1", @"guide_2", @"guide_3"]];
    guideView.enterButtonHidden = NO;
    guideView.pageControlHidden = NO;
    guideView.pageControlCurrentColor = [UIColor redColor];
    guideView.pageControlNomalColor = [UIColor grayColor];

作者：HCW

联系方式：599139419@qq.com

使用中如有疑问或有建议，欢迎打扰！
