//
//  ArticlePageView.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/19.
//

#import "ArticlePageView.h"
#import "ArticleCollectionViewCell.h"
#import "Masonry.h"
#import "Manager.h"

#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height

#define selfWidth self.frame.size.width

#define bottomBarHeight 48
#define bottomHeight 35
#define bottonNumberFontSize 16

@implementation ArticlePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //设置每个item的大小
    CGFloat itemHeight = 0;
    if (statusBarHeight == 20) {
        itemHeight = self.bounds.size.height - statusBarHeight - bottomBarHeight;
    } else {
        itemHeight = self.bounds.size.height - statusBarHeight - bottomBarHeight - bottomHeight;
    }
    layout.itemSize = CGSizeMake(self.bounds.size.width, itemHeight);
    
    //创建collectionView 通过一个布局策略layout来创建
    _collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, statusBarHeight, selfWidth, itemHeight) collectionViewLayout: layout];
    //代理设置
    _collect.delegate = self;
    _collect.dataSource = self;
    //注册item类型 这里使用系统的类型
    [_collect registerClass:[ArticleCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    _collect.pagingEnabled = YES;
    
    _collect.showsHorizontalScrollIndicator = NO;
//    [_collect setNeedsLayout];
    
    [self addSubview:_collect];
    
    [self initStatusBarView];
    [self initBottomBarView];
    
    return  self;
}

//返回每个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSString *ID = nil;
    if (_topOrNormal.intValue == 0) {
        ID = _topIdArray[indexPath.row];
    } else {
        ID = _idArray[indexPath.row + indexPath.section * 6];
    }
    NSString *urlString = [NSString stringWithFormat:@"https://daily.zhihu.com/story/%@", ID];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [cell.webView loadRequest:request];
//    NSLog(@"%p", cell);
//    NSLog(@"%f", _collect.contentSize.width);
    return cell;
}

//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
//    if (_topOrNormal.intValue == 0) {
//        return _topIdArray.count / 6;
//    } else {
//        return _idArray.count / 6;
//    }
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_topOrNormal.intValue == 0) {
        return _topIdArray.count;
    } else {
        return _idArray.count;
    }
//    return 6;
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView == _collect) && (_topOrNormal.intValue == 1)) {
        if(scrollView.contentSize.width != 0 && scrollView.contentOffset.x >= scrollView.contentSize.width - self.frame.size.width + 10) {
            NSNotification *notification = [NSNotification notificationWithName:@"updateData" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        if (((int)(_collect.contentOffset.x / selfWidth) == (_collect.contentOffset.x / selfWidth)) && ((int)(_collect.contentOffset.x / selfWidth) < _idArray.count)) {
            if ([_favoriteIDs containsObject: _idArray[(int)(_collect.contentOffset.x / selfWidth)]]) {
                _favoritesButton.tag = 1;
                [_favoritesButton setTintColor:[UIColor systemBlueColor]];
                [_favoritesButton setImage:[UIImage imageNamed:@"shoucang-2.png"] forState:UIControlStateNormal];
            } else {
                _favoritesButton.tag = 0;
                [_favoritesButton setTintColor:[UIColor blackColor]];
                [_favoritesButton setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
            }
            
            _initialPosition = [NSNumber numberWithInt:(int)(_collect.contentOffset.x / selfWidth)];
            [self initNumberLabel];
        }
    }
    if ((scrollView == _collect) && (_topOrNormal.intValue == 0)) {
        if ((int)(_collect.contentOffset.x / selfWidth) == (_collect.contentOffset.x / selfWidth)) {
            if ([_favoriteIDs containsObject: _topIdArray[(int)(_collect.contentOffset.x / selfWidth)]]) {
                _favoritesButton.tag = 1;
                [_favoritesButton setTintColor:[UIColor systemBlueColor]];
                [_favoritesButton setImage:[UIImage imageNamed:@"shoucang-2.png"] forState:UIControlStateNormal];
            } else {
                _favoritesButton.tag = 0;
                [_favoritesButton setTintColor:[UIColor blackColor]];
                [_favoritesButton setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
            }
            
            _initialPosition = [NSNumber numberWithInt:(int)(_collect.contentOffset.x / selfWidth)];
            [self initNumberLabel];
        }
    }
}

- (void)initStatusBarView {
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth, statusBarHeight)];
    [self addSubview:_statusBarView];
    _statusBarView.backgroundColor = [UIColor whiteColor];
}

- (void)initBottomBarView {
    
    CGFloat barHeight = 0;
    CGFloat itemHeight = 0;
    if (statusBarHeight == 20) {
        barHeight = bottomBarHeight;
        itemHeight = self.bounds.size.height - bottomBarHeight;
    } else {
        barHeight = bottomBarHeight + bottomHeight;
        itemHeight = self.bounds.size.height - bottomBarHeight - bottomHeight;
    }
    _bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight, selfWidth, barHeight)];
    [self addSubview:_bottomBarView];
    _bottomBarView.backgroundColor = [UIColor whiteColor];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_bottomBarView addSubview:_backButton];
    _backButton.frame = CGRectMake(0, 0, selfWidth / 6.5, bottomBarHeight);
    [_backButton setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [_backButton setTintColor:[UIColor blackColor]];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_bottomBarView addSubview:_commentButton];
    _commentButton.frame = CGRectMake(selfWidth / 6.5, 0, selfWidth * 5.5 / 6.5 / 4, bottomBarHeight);
    [_commentButton setTintColor:[UIColor blackColor]];
    [_commentButton setImage:[UIImage imageNamed:@"pinglun.png"] forState:UIControlStateNormal];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_bottomBarView addSubview:_likeButton];
    _likeButton.frame = CGRectMake(selfWidth / 6.5 + selfWidth * 5.5 / 6.5 / 4, 0, selfWidth * 5.5 / 6.5 / 4, bottomBarHeight);
    [_likeButton setTintColor:[UIColor blackColor]];
    [_likeButton setImage:[UIImage imageNamed:@"dianzan.png"] forState:UIControlStateNormal];
    
    _favoritesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_bottomBarView addSubview:_favoritesButton];
    _favoritesButton.frame = CGRectMake(selfWidth / 6.5 + selfWidth * 5.5 / 6.5 / 2, 0, selfWidth * 5.5 / 6.5 / 4, bottomBarHeight);
    [_favoritesButton setTintColor:[UIColor blackColor]];
    _favoritesButton.tag = 0;
    [_favoritesButton setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_bottomBarView addSubview:_shareButton];
    _shareButton.frame = CGRectMake(selfWidth / 6.5 + selfWidth * 5.5 / 6.5 / 4 * 3, 0, selfWidth * 5.5 / 6.5 / 4, bottomBarHeight);
    [_shareButton setTintColor:[UIColor blackColor]];
    [_shareButton setImage:[UIImage imageNamed:@"shangchuan.png"] forState:UIControlStateNormal];
    
    _numberOfLikesLabel = [[UILabel alloc] init];
    _numberOfLikesLabel.font = [UIFont systemFontOfSize:bottonNumberFontSize];
    [_likeButton addSubview:_numberOfLikesLabel];
    [_numberOfLikesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_likeButton.imageView.mas_right);
        make.top.mas_equalTo(_likeButton.imageView.mas_top);
    }];
    
    
    _numberOfCommentsLabel = [[UILabel alloc] init];
    _numberOfCommentsLabel.font = [UIFont systemFontOfSize:bottonNumberFontSize];
    [_likeButton addSubview:_numberOfCommentsLabel];
    [_numberOfCommentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_commentButton.imageView.mas_right).offset(2);
        make.top.mas_equalTo(_numberOfLikesLabel.mas_top);
    }];
}

- (void)initNumberLabel {
    if (_topOrNormal.intValue == 0) {
        [[Manager sharedManager] NetWorkExtraWithData:_topIdArray[_initialPosition.intValue] and:^(ExtraModel * _Nonnull mainViewNowModel){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_numberOfLikesLabel.text = [mainViewNowModel popularity];
                self->_numberOfCommentsLabel.text = [NSString stringWithFormat:@"%d", [mainViewNowModel long_comments].intValue + ([mainViewNowModel short_comments].intValue > 20 ? 20 : [mainViewNowModel short_comments].intValue)];
            });
        } error:^(NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
    } else {
        [[Manager sharedManager] NetWorkExtraWithData:_idArray[_initialPosition.intValue] and:^(ExtraModel * _Nonnull mainViewNowModel){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_numberOfLikesLabel.text = [mainViewNowModel popularity];
                self->_numberOfCommentsLabel.text = [NSString stringWithFormat:@"%d", [mainViewNowModel long_comments].intValue + ([mainViewNowModel short_comments].intValue > 20 ? 20 : [mainViewNowModel short_comments].intValue)];
            });
        } error:^(NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
    }
}

@end
