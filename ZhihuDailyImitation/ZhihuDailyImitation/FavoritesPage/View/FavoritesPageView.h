//
//  FavoritesPageView.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/31.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoritesPageView : UIView
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *favoriteTableView;

@property (nonatomic, strong) NSMutableArray *favoriteIDs;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, assign) NSInteger numberOfRows;

@property (nonatomic, strong) FMDatabase *dataBase;

@end

NS_ASSUME_NONNULL_END
