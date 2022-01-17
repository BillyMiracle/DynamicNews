//
//  MinePageViewController.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/19.
//

#import "MinePageViewController.h"
#import "MinePageView.h"
#import "FavoritesPageViewController.h"

@interface MinePageViewController ()

@property (nonatomic, strong) MinePageView *minePageView;
@property (nonatomic, strong) FavoritesPageViewController *favoritesPageViewController;

@end

@implementation MinePageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickFavorite" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickFavorite) name:@"clickFavorite" object:nil];
    
    _minePageView = [[MinePageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_minePageView];
    [_minePageView.backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickFavorite {
    _favoritesPageViewController = [[FavoritesPageViewController alloc] init];
    _favoritesPageViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_favoritesPageViewController animated:YES completion:nil];
}

- (void)pressBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
