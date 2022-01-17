//
//  MainPageView.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainPageView : UIView
<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    NSTimer *scrollTimer;
}
//@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *navBarView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIImageView *loadView;

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *headButton;

@property (nonatomic, strong) UIScrollView *headScrollView;
@property (nonatomic, strong) UIPageControl *headPageControl;

@property (nonatomic, strong) NSMutableArray *topStoriesImages;
@property (nonatomic, strong) NSMutableArray *topStoriesTitles;
@property (nonatomic, strong) NSMutableArray *topStoriesHints;
@property (nonatomic, strong) NSMutableArray *topImagesDataArray;

@property (nonatomic, strong) NSMutableArray *storiesImages;
@property (nonatomic, strong) NSMutableArray *storiesTitles;
@property (nonatomic, strong) NSMutableArray *storiesHints;
@property (nonatomic, strong) NSMutableArray *normalImagesDataArray;

@property (nonatomic, strong) NSMutableArray *dates;

@property (nonatomic, strong) NSDate *todayDate;

@property (nonatomic, strong) NSNumber *days;
@property (nonatomic, assign) BOOL shouldUpdate;

@property (nonatomic, assign) NSInteger numberOfSections;

@property (nonatomic, assign) BOOL networkConnection;

- (void)addNavBarView;

@end

NS_ASSUME_NONNULL_END
