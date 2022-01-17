//
//  FavoritesPageView.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/31.
//

#import "FavoritesPageView.h"
#import "FavoritesTableViewCell.h"
#import "SDWebImage.h"

#define selfWidth self.frame.size.width
#define selfHeight self.frame.size.height
#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#define navBarHeight 45

#define titleLabelFontSize 24

@implementation FavoritesPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    _favoriteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight + navBarHeight, selfWidth, selfHeight - (statusBarHeight + navBarHeight)) style:UITableViewStyleGrouped];
    _favoriteTableView.sectionHeaderHeight = 0;
    [self addSubview:_favoriteTableView];
    _favoriteTableView.delegate = self;
    _favoriteTableView.dataSource = self;
    _favoriteTableView.showsVerticalScrollIndicator = NO;
    _favoriteTableView.backgroundColor = [UIColor whiteColor];
    [_favoriteTableView registerClass:[FavoritesTableViewCell class] forCellReuseIdentifier:@"favoriteCell"];
    
    [self addTopView];
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesTableViewCell *cell = [_favoriteTableView dequeueReusableCellWithIdentifier:@"favoriteCell" forIndexPath:indexPath];
    
    NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
    if (@available(iOS 9.0, *)) {
        descStyle.allowsDefaultTighteningForTruncation  = YES;
        descStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    cell.cellTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:_titles[indexPath.row] attributes:@{NSParagraphStyleAttributeName: descStyle}];
    
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:_images[indexPath.row]] placeholderImage:[UIImage imageNamed:@"wufajiazai.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger number = indexPath.row;
    NSNotification *notification = [NSNotification notificationWithName:@"clickFavorite" object:nil userInfo:@{@"key":[NSNumber numberWithInteger: number]}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, 30)];
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"没有更多内容";
    hintLabel.font = [UIFont systemFontOfSize:titleLabelFontSize - 5];
    hintLabel.textColor = [UIColor lightGrayColor];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.frame = CGRectMake(0, (30 - hintLabel.font.lineHeight) / 2, selfWidth, hintLabel.font.lineHeight);
    [footView addSubview:hintLabel];
    return footView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_favoriteTableView.contentOffset.y <= 0) {
        _favoriteTableView.bounces = NO;
    } else if (_favoriteTableView.contentOffset.y >= 0) {
        _favoriteTableView.bounces = YES;
    }
}

- (void)addTopView {
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, statusBarHeight + navBarHeight)];

    _topView.backgroundColor = [UIColor whiteColor];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _backButton.frame = CGRectMake(0, statusBarHeight + 5, 50, 35);
    [_backButton setTintColor:[UIColor blackColor]];
    [_backButton setImage:[UIImage imageNamed:@"iconfont-left.png"] forState:UIControlStateNormal];
    [_topView addSubview:_backButton];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:titleLabelFontSize];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_titleLabel];
    _titleLabel.text = @"收藏";
    _titleLabel.frame = CGRectMake(50, statusBarHeight + (navBarHeight - _titleLabel.font.lineHeight) / 2, selfWidth - 100, _titleLabel.font.lineHeight);
    
    [self addSubview:_topView];
}

- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        [self delete: [self.favoriteIDs objectAtIndex: self.favoriteIDs.count - 1 - indexPath.row]];
        [self.favoriteIDs removeObjectAtIndex: self.favoriteIDs.count - 1 - indexPath.row];
        [self.titles removeObjectAtIndex: indexPath.row];
        [self.images removeObjectAtIndex: indexPath.row];
        self.numberOfRows--;
        completionHandler (YES);
        [self.favoriteTableView reloadData];
    }];
    
    deleteRowAction.title = @"取消收藏";
    deleteRowAction.backgroundColor = [UIColor systemRedColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

-(void)delete:(NSString *)ID//删除数据
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documents firstObject];
    NSString *favoriteFilePath = [documentsPath stringByAppendingPathComponent:@"favourites.db"];
//    NSLog(@"%@", _favoriteFilePath);
    _dataBase = [FMDatabase databaseWithPath: favoriteFilePath];
    [_dataBase open];
    NSString *deleteSQL=@"delete from ObjectTable where Name=? ";
    BOOL success=[_dataBase executeUpdate:deleteSQL, ID];
    if (success) {
//        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

@end
