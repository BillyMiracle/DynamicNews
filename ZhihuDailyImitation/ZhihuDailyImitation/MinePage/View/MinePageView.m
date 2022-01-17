//
//  MinePageView.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/19.
//

#import "MinePageView.h"
#import "Masonry.h"

#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height


@implementation MinePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _backButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _backButton.frame = CGRectMake(0, statusBarHeight, 50, 35);
    [_backButton setImage:[UIImage imageNamed:@"iconfont-left.png"] forState:UIControlStateNormal];
    _backButton.tintColor = [UIColor darkGrayColor];
    [self addSubview:_backButton];
    
    _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight + 50, self.frame.size.width, self.frame.size.height - 50 - statusBarHeight - 100) style:UITableViewStylePlain];
    [self addSubview:_mineTableView];
    _mineTableView.delegate = self;
    _mineTableView.dataSource = self;
    _mineTableView.bounces = NO;
    _mineTableView.showsVerticalScrollIndicator = NO;
    _mineTableView.showsHorizontalScrollIndicator = NO;
    
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        NSNotification *notification = [NSNotification notificationWithName:@"clickFavorite" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.mineTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HEAD.jpg"]];
        [cell.contentView addSubview:_headImageView];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 60;
        _headImageView.layer.borderWidth = 0;
        
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@120);
            make.height.mas_equalTo(@120);
            make.centerX.mas_equalTo(cell.contentView.mas_centerX);
            make.top.mas_equalTo(@5);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        [cell.contentView addSubview:_nameLabel];
        _nameLabel.font = [UIFont systemFontOfSize:24];
        _nameLabel.text = @"Billy Watson";
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(cell.contentView.mas_centerX);
            make.top.mas_equalTo(_headImageView.mas_bottom).offset(5);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom).offset(-10);
        }];
        
    } else if (indexPath.row == 1) {
        
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.text = @"我的收藏";
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
            make.top.mas_equalTo(cell.contentView.mas_top).offset(15);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom).offset(-15);
        }];
        
    } else {
        
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.text = @"消息中心";
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
            make.top.mas_equalTo(cell.contentView.mas_top).offset(15);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom).offset(-15);
        }];
        
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

@end
