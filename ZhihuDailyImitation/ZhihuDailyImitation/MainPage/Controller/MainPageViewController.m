//
//  MainPageViewController.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/17.
//

#import "MainPageViewController.h"
#import "Masonry.h"
#import "Manager.h"
#import "MainPageView.h"
#import "MinePageViewController.h"
#import "ArticlePageViewController.h"
#import "ArticlePageView.h"
#import "FMDB.h"
#import "SDWebImage.h"

#define selfWidth self.view.frame.size.width

@interface MainPageViewController ()

@property (nonatomic, strong) MainPageView *mainPageView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) MinePageViewController *minePageViewController;
@property (nonatomic, strong) ArticlePageViewController *articlePageViewController;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSString *objectsFilePath;
@property (nonatomic, strong) FMDatabase *stringDataBase;
@property (nonatomic, strong) FMDatabase *imageDataBase;
@property (nonatomic, strong) NSString *imageObjectsFilePath;

@end

@implementation MainPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_mainPageView.headScrollView) {
        if (_mainPageView.headScrollView.contentOffset.x > _mainPageView.headScrollView.contentSize.width) {
            NSLog(@"Wrong Position!!!");
            [_mainPageView.headScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            _mainPageView.headPageControl.currentPage = 1;
        }
    }
    if (_mainPageView.headPageControl) {
        CGFloat offset = _mainPageView.headScrollView.contentOffset.x;
        CGFloat pagewi = selfWidth;
        _mainPageView.headPageControl.currentPage = (int)(offset / pagewi) % 5;
//        NSLog(@"%ld", _mainPageView.headPageControl.currentPage);
    }
    
    _index = 0;
    
}
//在这里注册会出现问题，因为页面多次出现会导致注册了多次，放到viewDidLoad就好了

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getBefore" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pressHead" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickTopStory" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickStory" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册通知 添加观察者来指定一个方法，名称和对象，接受到通知时执行这个指定的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pressHead:) name:@"pressHead" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBefore:) name:@"getBefore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickTopStory:) name:@"clickTopStory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickStory:) name:@"clickStory" object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainPageView = [[MainPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_mainPageView];
    
    _articlePageViewController = [[ArticlePageViewController alloc] init];
    _articlePageViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyyMMdd"];
    
    [self getLatest];
}

# pragma mark GetLatest
- (void)getLatest {
    [self creatTable];
    self->_mainPageView.numberOfSections = 0;
    [[Manager sharedManager] NetWorkWithLatestData:^(LatestModel * _Nonnull mainViewNowModel) {
        [self delete];
        
        self->_mainPageView.todayDate = [self->_dateFormatter dateFromString:mainViewNowModel.date];
        
        self->_mainPageView.dates = [[NSMutableArray alloc] init];
        self->_mainPageView.storiesImages = [[NSMutableArray alloc] init];
        self->_mainPageView.storiesTitles = [[NSMutableArray alloc] init];
        self->_mainPageView.storiesHints = [[NSMutableArray alloc] init];
        
        self->_mainPageView.topStoriesImages = [[NSMutableArray alloc] init];
        self->_mainPageView.topStoriesTitles = [[NSMutableArray alloc] init];
        self->_mainPageView.topStoriesHints = [[NSMutableArray alloc] init];
        
        self->_articlePageViewController.topIdArray = [[NSMutableArray alloc] init];
        self->_articlePageViewController.idArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < mainViewNowModel.stories.count; ++i) {
            NSArray *images = [mainViewNowModel.stories[i] images];
            [self->_mainPageView.storiesImages addObject:images[0]];
            [self->_mainPageView.storiesTitles addObject:[mainViewNowModel.stories[i] title]];
            [self->_mainPageView.storiesHints addObject:[mainViewNowModel.stories[i] hint]];
            [self->_articlePageViewController.idArray addObject:[mainViewNowModel.stories[i] id]];
            [self insert:@1 title:[mainViewNowModel.stories[i] title] hint:[mainViewNowModel.stories[i] hint] ID:[mainViewNowModel.stories[i] id]];
        }
        
        for (int i = 0; i < mainViewNowModel.top_stories.count; ++i) {
            [self->_mainPageView.topStoriesImages addObject:[mainViewNowModel.top_stories[i] image]];
            [self->_mainPageView.topStoriesTitles addObject:[mainViewNowModel.top_stories[i] title]];
            [self->_mainPageView.topStoriesHints addObject:[mainViewNowModel.top_stories[i] hint]];
            [self->_articlePageViewController.topIdArray addObject:[mainViewNowModel.top_stories[i] id]];
            [self insert:@0 title:[mainViewNowModel.top_stories[i] title] hint:[mainViewNowModel.top_stories[i] hint] ID:[mainViewNowModel.top_stories[i] id]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_mainPageView.networkConnection = YES;
            self->_mainPageView.numberOfSections = 1;
            [self->_mainPageView.mainTableView reloadData];
            [self->_mainPageView addNavBarView];
        });
    } error:^(NSError * _Nonnull error) {
        self->_mainPageView.networkConnection = NO;
        self->_mainPageView.todayDate = [NSDate date];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self select];
            self->_mainPageView.numberOfSections = 1;
            [self->_mainPageView.mainTableView reloadData];
            [self->_mainPageView addNavBarView];
            UIAlertController *firstAlertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"无网络连接，请检查网络" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [firstAlertController addAction:confirm];
            [self presentViewController: firstAlertController animated:YES completion:nil];
        });
    }];
}

# pragma mark GetBefore

- (void)getBefore: (NSNotification *)notification {
//    if (_mainPageView.networkConnection == NO) {
//        [self getLatest];
//    }
    NSString *date = [_dateFormatter stringFromDate:[_mainPageView.todayDate dateByAddingTimeInterval: -24 * 60 * 60 * _mainPageView.days.intValue]];
    [self->_mainPageView.dates addObject:[_mainPageView.todayDate dateByAddingTimeInterval: -24 * 60 * 60 * (_mainPageView.days.intValue + 1)]];
    _mainPageView.days = [NSNumber numberWithInt:_mainPageView.days.intValue + 1];
    
    [[Manager sharedManager] NetWorkWithBeforeData:date and:^(LatestModel * _Nonnull mainViewNowModel) {
        self->_mainPageView.networkConnection = YES;
        for (int i = 0; i < mainViewNowModel.stories.count; ++i) {
            NSArray *images = [mainViewNowModel.stories[i] images];
            [self->_mainPageView.storiesImages addObject:images[0]];
            [self->_mainPageView.storiesTitles addObject:[mainViewNowModel.stories[i] title]];
            [self->_mainPageView.storiesHints addObject:[mainViewNowModel.stories[i] hint]];
            [self->_articlePageViewController.idArray addObject:[mainViewNowModel.stories[i] id]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->_index == 2) {
                self->_mainPageView.numberOfSections += 3;
                [self->_mainPageView.mainTableView reloadData];
                [self->_mainPageView.loadView.layer removeAllAnimations];
//                [CATransaction setDisableActions:YES];
                [self->_articlePageViewController reload];
//                [CATransaction commit];
                self->_index = 0;
            } else {
                self->_index++;
                NSNotification *notification2 = [NSNotification notificationWithName:@"getBefore" object:nil userInfo:@{@"Days" : self->_mainPageView.days}];
                [self getBefore:notification2];
            }
        });
    } error:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_mainPageView.shouldUpdate = YES;
        });
    }];
}

- (void)pressHead:(NSNotification*)notification {
    _minePageViewController = [[MinePageViewController alloc] init];
    _minePageViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_minePageViewController animated:YES completion:nil];
}

#pragma mark 点击事件
- (void)clickTopStory:(NSNotification*)notification {
    
    NSDictionary *dict = notification.userInfo;
    NSNumber *key = dict[@"key"];
    
    _articlePageViewController.topOrNormal = [NSNumber numberWithInt: 0];
    _articlePageViewController.initialPosition = [NSNumber numberWithInt: key.intValue - 100];
    _articlePageViewController.articlePageView = [[ArticlePageView alloc] initWithFrame: self.view.frame];
    [_articlePageViewController.view addSubview:_articlePageViewController.articlePageView];
    
    [self presentViewController:_articlePageViewController animated:YES completion:nil];
}

- (void)clickStory:(NSNotification*)notification {
    
    NSDictionary *dict = notification.userInfo;
    NSNumber *key = dict[@"key"];
    
    _articlePageViewController.topOrNormal = [NSNumber numberWithInt: 1];
    _articlePageViewController.initialPosition = [NSNumber numberWithInt: key.intValue];
    _articlePageViewController.articlePageView = [[ArticlePageView alloc] initWithFrame: self.view.frame];
    [_articlePageViewController.view addSubview:_articlePageViewController.articlePageView];
    
    [self presentViewController: _articlePageViewController animated:YES completion:nil];
}
#pragma mark CreatTable
- (void)creatTable {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documents firstObject];
    _objectsFilePath = [documentsPath stringByAppendingPathComponent:@"objects.db"];
    _stringDataBase = [FMDatabase databaseWithPath:_objectsFilePath];
    if ([_stringDataBase open]) {
//        NSLog(@"打开成功");
        NSString *createTableSql = @"create table if not exists ObjectTable(id integer primary key autoincrement,Type integer,Titles text,Hints text,IDs text)";
        BOOL success=[_stringDataBase executeUpdate:createTableSql];
        if (success) {
//            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    } else {
        NSLog(@"打开失败");
    }
    _imageObjectsFilePath = [documentsPath stringByAppendingPathComponent:@"images.db"];
    _imageDataBase = [FMDatabase databaseWithPath:_imageObjectsFilePath];
    if ([_imageDataBase open]) {
//        NSLog(@"打开成功");
        NSString *createTableSql = @"create table if not exists ObjectTable(id integer primary key autoincrement,Type integer,Image bolb)";
        BOOL success=[_imageDataBase executeUpdate:createTableSql];
        if (success) {
//            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    } else {
        NSLog(@"打开失败");
    }
}

-(void)insert:(NSNumber *)Type title:(NSString *)Titles hint:(NSString *)Hints ID:(NSString *)IDs{
    NSString *insertSQL=@"insert into ObjectTable (Type,Titles,Hints,IDs) values (?,?,?,?)";
    BOOL success=[_stringDataBase executeUpdate:insertSQL, Type, Titles, Hints, IDs];
    if (success) {
//        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

- (void)select {
    
    _mainPageView.dates = [[NSMutableArray alloc] init];
    _mainPageView.storiesTitles = [[NSMutableArray alloc] init];
    _mainPageView.storiesHints = [[NSMutableArray alloc] init];
    _mainPageView.normalImagesDataArray = [[NSMutableArray alloc] init];
    
    _mainPageView.topStoriesTitles = [[NSMutableArray alloc] init];
    _mainPageView.topStoriesHints = [[NSMutableArray alloc] init];
    _mainPageView.topImagesDataArray = [[NSMutableArray alloc] init];
    
    _articlePageViewController.topIdArray = [[NSMutableArray alloc] init];
    _articlePageViewController.idArray = [[NSMutableArray alloc] init];
    
    NSString *selectSQL=@"select * from ObjectTable";
    FMResultSet *set = [_stringDataBase executeQuery:selectSQL];
    //需要对结果集进行遍历操作
    while ([set next]) {
        NSInteger topOrNormal = [set intForColumn:@"Type"];
        NSString *title = [set stringForColumn:@"Titles"];
        NSString *hint = [set stringForColumn:@"Hints"];
        NSString *ID = [set stringForColumn:@"IDs"];
        if (topOrNormal == 1) {
            [_mainPageView.storiesTitles addObject:title];
            [_mainPageView.storiesHints addObject:hint];
            [_articlePageViewController.idArray addObject:ID];
        } else {
            [_mainPageView.topStoriesTitles addObject:title];
            [_mainPageView.topStoriesHints addObject:hint];
            [_articlePageViewController.topIdArray addObject:ID];
        }
    }
    set = [_imageDataBase executeQuery:selectSQL];
    while ([set next]) {
        NSInteger topOrNormal = [set intForColumn:@"Type"];
        NSData * imgData = [set dataForColumn:@"Image"];
//        NSLog(@"%ld %@", topOrNormal, imgData);
        if (topOrNormal == 1) {
            [_mainPageView.normalImagesDataArray addObject:imgData];
        } else {
            [_mainPageView.topImagesDataArray addObject:imgData];
        }
    }
}

- (void)delete {
    NSString *deleteSQL = @"delete from ObjectTable where 1";
    BOOL success = [_stringDataBase executeUpdate:deleteSQL];
    if (success) {
//        NSLog(@"删除成功");
    } else {
        NSLog(@"0删除失败");
    }
    deleteSQL = @"delete from ObjectTable where 1";
    success = [_imageDataBase executeUpdate:deleteSQL];
    if (success) {
//        NSLog(@"删除成功");
    } else {
        NSLog(@"0删除失败");
    }
}
@end
