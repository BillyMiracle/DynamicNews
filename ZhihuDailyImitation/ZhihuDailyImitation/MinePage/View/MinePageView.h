//
//  MinePageView.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinePageView : UIView
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UITableView *mineTableView;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
