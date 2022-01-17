//
//  MainPageCell.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainPageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *cellImageView;

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UILabel *cellHintLabel;

@property (nonatomic, strong) UILabel *cellDateLabel;
@property (nonatomic, strong) UIView *cellLineView;

@end

NS_ASSUME_NONNULL_END
