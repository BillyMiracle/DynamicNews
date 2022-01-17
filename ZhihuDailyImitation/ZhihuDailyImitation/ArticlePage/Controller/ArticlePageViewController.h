//
//  ArticlePageViewController.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/19.
//

#import <UIKit/UIKit.h>
#import "ArticlePageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticlePageViewController : UIViewController

@property (nonatomic, strong) ArticlePageView *articlePageView;

@property (nonatomic, copy) NSNumber *topOrNormal;
@property (nonatomic, copy) NSNumber *initialPosition;

@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *topIdArray;

- (void) reload;

@end

NS_ASSUME_NONNULL_END
