//
//  CommentPageView.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentPageView : UIView
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UITableView *commentTableView;



@property (nonatomic, assign) NSInteger numberOfSections;
//数据区
@property (nonatomic, strong) NSMutableArray *longComments;
@property (nonatomic, strong) NSMutableArray *longCommentAuthors;
@property (nonatomic, strong) NSMutableArray *longCommentHeadImages;
@property (nonatomic, strong) NSMutableArray *longCommentNumberOfLikes;
@property (nonatomic, strong) NSMutableArray *longCommentReplyTo;
@property (nonatomic, strong) NSMutableArray *longCommentTime;
@property (nonatomic, strong) NSMutableArray *longCommentShouldFold;

@property (nonatomic, strong) NSMutableArray *shortComments;
@property (nonatomic, strong) NSMutableArray *shortCommentAuthors;
@property (nonatomic, strong) NSMutableArray *shortCommentHeadImages;
@property (nonatomic, strong) NSMutableArray *shortCommentNumberOfLikes;
@property (nonatomic, strong) NSMutableArray *shortCommentReplyTo;
@property (nonatomic, strong) NSMutableArray *shortCommentTime;
@property (nonatomic, strong) NSMutableArray *shortCommentShouldFold;

- (void)initNumberLabel;

@end

NS_ASSUME_NONNULL_END
