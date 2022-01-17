//
//  FavoritesPageViewController.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/31.
//

#import "FavoritesPageViewController.h"
#import "ArticlePageViewController.h"
#import "FavoritesPageView.h"
#import "FMDB.h"
#import "Manager.h"

@interface FavoritesPageViewController ()

@property (nonatomic, strong) FavoritesPageView *favoritesPageView;

@property (nonatomic, strong) NSString *favoriteFilePath;
@property (nonatomic, strong) FMDatabase *dataBase;

@property (nonatomic, strong) ArticlePageViewController *articlePageViewController;

@property (nonatomic, assign) NSInteger number;

@end

@implementation FavoritesPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@", _favoritesPageView.favoriteIDs);
    

    [self select];
    _favoritesPageView.titles = [[NSMutableArray alloc] init];
    _favoritesPageView.images = [[NSMutableArray alloc] init];
    _favoritesPageView.numberOfRows = 0;
    
    _articlePageViewController.topIdArray = [[NSMutableArray alloc] init];
    
    _number = 0;
    [self getData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickStory:) name:@"clickFavorite" object:nil];
    
    [self creatTable];
    
    _favoritesPageView = [[FavoritesPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_favoritesPageView];
    
    [_favoritesPageView.backButton addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    
    _articlePageViewController = [[ArticlePageViewController alloc] init];
    _articlePageViewController.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)creatTable {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documents firstObject];
    _favoriteFilePath = [documentsPath stringByAppendingPathComponent:@"favourites.db"];
//    NSLog(@"%@", _favoriteFilePath);
    _dataBase = [FMDatabase databaseWithPath:_favoriteFilePath];
    if ([_dataBase open]) {
//        NSLog(@"打开成功");
        NSString *createTableSql = @"create table if not exists ObjectTable(id integer primary key autoincrement,Name text)";
        BOOL success=[_dataBase executeUpdate:createTableSql];
        if (success) {
//            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    } else {
        NSLog(@"打开失败");
    }
}

- (void)select//查询数据
{
    _favoritesPageView.favoriteIDs = [[NSMutableArray alloc] init];
    NSString *selectSQL = @"select * from ObjectTable";
    FMResultSet *set = [_dataBase executeQuery:selectSQL];
    //需要对结果集进行遍历操作
    while ([set next]) {
    //获取下一跳记录,如果没有下一条,返回NO;
    //取数据
        NSString *ID = [set stringForColumn:@"Name"];
//        NSInteger num = [set intForColumn:@"id"];
        [_favoritesPageView.favoriteIDs addObject:ID];
//        NSLog(@"%@, ID=%ld", ID, num);
    }
    
}

- (void)getData {
    if (_number < _favoritesPageView.favoriteIDs.count) {
        [[Manager sharedManager] NetWorkFavoriteWithData:_favoritesPageView.favoriteIDs[_favoritesPageView.favoriteIDs.count - 1 - _number] and:^(FavoriteModel * _Nonnull mainViewNowModel) {
            [self->_favoritesPageView.titles addObject:mainViewNowModel.title];
            [self->_favoritesPageView.images addObject:mainViewNowModel.image];
//            [self->_articlePageViewController.topIdArray addObject:self->_favoritesPageView.favoriteIDs[self->_number]];
//            NSLog(@"%@", self->_favoritesPageView.titles);
//            NSLog(@"%@", self->_favoritesPageView.images);
            self->_favoritesPageView.numberOfRows++;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ((self->_number == self->_favoritesPageView.favoriteIDs.count - 1) || (!(self->_number % 8) && self->_number != 0)) {
                    [self->_favoritesPageView.favoriteTableView reloadData];
                }
                self->_number++;
                [self getData];
            });
        } error:^(NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
    }
}

- (void)clickStory:(NSNotification*)notification {
    
    NSDictionary *dict = notification.userInfo;
    NSNumber *key = dict[@"key"];
    
    _articlePageViewController.topOrNormal = [NSNumber numberWithInt: 0];
    _articlePageViewController.initialPosition = [NSNumber numberWithInt: key.intValue];
    _articlePageViewController.articlePageView = [[ArticlePageView alloc] initWithFrame: self.view.frame];
    NSLog(@"%@", _favoritesPageView.favoriteIDs);
    _articlePageViewController.topIdArray = [NSMutableArray arrayWithArray:_favoritesPageView.favoriteIDs.reverseObjectEnumerator.allObjects];
    [_articlePageViewController.view addSubview:_articlePageViewController.articlePageView];
    [self presentViewController: _articlePageViewController animated:YES completion:nil];
}

- (void)pressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
