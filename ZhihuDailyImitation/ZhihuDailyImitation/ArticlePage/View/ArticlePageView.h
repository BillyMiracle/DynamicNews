//
//  ArticlePageView.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/19.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticlePageView : UIView
<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *topIdArray;

@property (nonatomic, copy) NSNumber *topOrNormal;
@property (nonatomic, copy) NSNumber *initialPosition;

@property (nonatomic, copy) NSNumber *sectionNumber;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UICollectionView * collect;

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *bottomBarView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *favoritesButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UILabel *numberOfLikesLabel;
@property (nonatomic, strong) UILabel *numberOfCommentsLabel;

@property (nonatomic, strong) NSMutableArray *favoriteIDs;

- (void)initNumberLabel;

@end

NS_ASSUME_NONNULL_END
