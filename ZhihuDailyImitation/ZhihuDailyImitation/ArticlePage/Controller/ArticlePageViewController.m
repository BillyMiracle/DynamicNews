//
//  ArticlePageViewController.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/19.
//

#import "ArticlePageViewController.h"
#import "CommentPageViewController.h"
#import "FMDB.h"

#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height

#define bottomBarHeight 48
#define bottomHeight 35

#define selfWidth self.view.frame.size.width

@interface ArticlePageViewController ()

@property (nonatomic, strong) CommentPageViewController *commentPageViewController;

@property (nonatomic, strong) NSString *favoriteFilePath;
@property (nonatomic, strong) FMDatabase *dataBase;

@end

@implementation ArticlePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _articlePageView.topOrNormal = [NSNumber numberWithInt:_topOrNormal.intValue];
    
    _articlePageView.topIdArray = [NSMutableArray arrayWithArray:self.topIdArray];
    _articlePageView.idArray = [NSMutableArray arrayWithArray:self.idArray];
    
    [_articlePageView.backButton addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    [_articlePageView.commentButton addTarget:self action:@selector(pressComment) forControlEvents:UIControlEventTouchUpInside];
    [_articlePageView.favoritesButton addTarget:self action:@selector(pressFavorite:) forControlEvents:UIControlEventTouchUpInside];
    
    _articlePageView.favoriteIDs = [[NSMutableArray alloc] init];
    [self select];
    
    _articlePageView.initialPosition = _initialPosition;
    [_articlePageView.collect setContentOffset:CGPointMake(self.view.frame.size.width * _initialPosition.intValue, 0) animated:NO];
    
    if (_topOrNormal.intValue == 0) {
        if ([_articlePageView.favoriteIDs containsObject:_articlePageView.topIdArray[_initialPosition.intValue]]) {
            _articlePageView.favoritesButton.tag = 1;
            [_articlePageView.favoritesButton setTintColor:[UIColor systemBlueColor]];
            [_articlePageView.favoritesButton setImage:[UIImage imageNamed:@"shoucang-2.png"] forState:UIControlStateNormal];
        }
    } else {
        if ([_articlePageView.favoriteIDs containsObject:_articlePageView.idArray[_initialPosition.intValue]]) {
            _articlePageView.favoritesButton.tag = 1;
            [_articlePageView.favoritesButton setTintColor:[UIColor systemBlueColor]];
            [_articlePageView.favoritesButton setImage:[UIImage imageNamed:@"shoucang-2.png"] forState:UIControlStateNormal];
        }
    }
    
    [_articlePageView initNumberLabel];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTable];
    
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
#pragma mark Reload
- (void)reload {
    if (_articlePageView.collect != nil) {
        _articlePageView.idArray = [NSMutableArray arrayWithArray: self.idArray];
        
        CGFloat h = _articlePageView.collect.contentSize.height;
        CGFloat w = _articlePageView.collect.contentSize.width + 18 * selfWidth;

        _articlePageView.collect.contentSize = CGSizeMake(w, h);

        [_articlePageView.collect reloadData];
    }
}

- (void)pressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressComment {
    _commentPageViewController = [[CommentPageViewController alloc] init];
    _commentPageViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    if (_topOrNormal.intValue == 0) {
        _commentPageViewController.currentId = [NSString stringWithString:_articlePageView.topIdArray[(int)(_articlePageView.collect.contentOffset.x / self.view.frame.size.width)]];
    } else {
        _commentPageViewController.currentId = [NSString stringWithString:_articlePageView.idArray[(int)(_articlePageView.collect.contentOffset.x / self.view.frame.size.width)]];
    }
    _initialPosition = [NSNumber numberWithInt:(int)(_articlePageView.collect.contentOffset.x / self.view.frame.size.width)];
    [self presentViewController:_commentPageViewController animated:YES completion:nil];
}

- (void)pressFavorite:(UIButton *)button {
    if (_topOrNormal.intValue == 0) {
        if (button.tag == 0) {
            [_articlePageView.favoriteIDs addObject:_topIdArray[(int)(_articlePageView.collect.contentOffset.x / selfWidth)]];
            button.tag = 1;
            [button setTintColor:[UIColor systemBlueColor]];
            [button setImage:[UIImage imageNamed:@"shoucang-2.png"] forState:UIControlStateNormal];
            [self insert:_topIdArray[(int)(_articlePageView.collect.contentOffset.x / selfWidth)]];
        } else {
            [_articlePageView.favoriteIDs removeObject:_topIdArray[(int)(_articlePageView.collect.contentOffset.x / selfWidth)]];
            button.tag = 0;
            [button setTintColor:[UIColor blackColor]];
            [button setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
            [self delete:_topIdArray[(int)(_articlePageView.collect.contentOffset.x / selfWidth)]];
        }
    } else {
        if (button.tag == 0) {
            [_articlePageView.favoriteIDs addObject:_idArray[(int)(_articlePageView.collect.contentOffset.x / selfWidth)]];
            button.tag = 1;
            [button setTintColor:[UIColor systemBlueColor]];
            [button setImage:[UIImage imageNamed:@"shoucang-2.png"] forState:UIControlStateNormal];
            [self insert:_idArray[(int)(_articlePageView.collect.contentOffset.x / selfWidth)]];
        } else {
            [_articlePageView.favoriteIDs removeObject:_idArray[(int)(_articlePageView.collect.contentOffset.x / selfWidth)]];
            button.tag = 0;
            [button setTintColor:[UIColor blackColor]];
            [button setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
            [self delete:_idArray[(int)(_articlePageView.collect.contentOffset.x / selfWidth)]];
        }
    }
    
}

- (void)select//查询数据
{
    NSString *selectSQL=@"select * from ObjectTable";
    FMResultSet *set = [_dataBase executeQuery:selectSQL];
    //需要对结果集进行遍历操作
    while ([set next]) {
        //获取下一条记录,如果没有下一条,返回NO;
        //取数据
        NSString *ID = [set stringForColumn:@"Name"];
//        NSInteger num = [set intForColumn:@"id"];
        [_articlePageView.favoriteIDs addObject:ID];
//        NSLog(@"%@, ID=%ld", ID, num);
    }
}

-(void)insert:(NSString *)ID//插入数据
{
    NSString *insertSQL=@"insert into ObjectTable (Name) values (?)";
    BOOL success=[_dataBase executeUpdate:insertSQL, ID];
    if (success) {
//        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

-(void)delete:(NSString *)ID//删除数据
{
    NSString *deleteSQL=@"delete from ObjectTable where Name=? ";
    BOOL success=[_dataBase executeUpdate:deleteSQL, ID];
    if (success) {
//        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

@end
