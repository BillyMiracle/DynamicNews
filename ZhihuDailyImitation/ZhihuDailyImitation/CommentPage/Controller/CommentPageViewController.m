//
//  CommentPageViewController.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/24.
//

#import "CommentPageViewController.h"
#import "CommentPageView.h"
#import "Manager.h"

@interface CommentPageViewController ()

@property (nonatomic, strong) CommentPageView *commentPageView;

@property (nonatomic, copy) NSString *replyString;

@end

@implementation CommentPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commentPageView = [[CommentPageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_commentPageView];
    
    [_commentPageView.backButton addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    
    _commentPageView.numberOfSections = 1;
    [self getLongComments: _currentId];
    
}

- (void)getLongComments:(NSString *) currentId {
    [[Manager sharedManager] NetWorkGetLongCommentsWithData:currentId and:^(LongCommentModel * _Nonnull longCommentModel) {
        self->_commentPageView.longComments = [[NSMutableArray alloc] init];
        self->_commentPageView.longCommentAuthors = [[NSMutableArray alloc] init];
        self->_commentPageView.longCommentHeadImages = [[NSMutableArray alloc] init];
        self->_commentPageView.longCommentNumberOfLikes = [[NSMutableArray alloc] init];
        self->_commentPageView.longCommentReplyTo = [[NSMutableArray alloc] init];
        self->_commentPageView.longCommentTime = [[NSMutableArray alloc] init];
        self->_commentPageView.longCommentShouldFold = [[NSMutableArray alloc] init];
//        NSLog(@"%@", self->_currentId);
        if (longCommentModel.comments.count != 0) {
            self->_commentPageView.numberOfSections = 2;
        }
        for (int i = 0; i < longCommentModel.comments.count; ++i) {
            [self->_commentPageView.longComments addObject:[longCommentModel.comments[i] content]];
            [self->_commentPageView.longCommentAuthors addObject:[longCommentModel.comments[i] author]];
            [self->_commentPageView.longCommentHeadImages addObject:[longCommentModel.comments[i] avatar]];
            [self->_commentPageView.longCommentNumberOfLikes addObject:[longCommentModel.comments[i] likes]];
            [self->_commentPageView.longCommentTime addObject:[longCommentModel.comments[i] time]];
            [self->_commentPageView.longCommentShouldFold addObject:@0];
            if ([longCommentModel.comments[i] reply_to] != nil) {
                if ([[longCommentModel.comments[i] reply_to] author] == nil || [[longCommentModel.comments[i] reply_to] content] == nil) {
                    self->_replyString = @"抱歉，原点评已经被删除";
                } else {
                    self->_replyString = [NSString stringWithFormat:@"// %@ ：%@", [[longCommentModel.comments[i] reply_to] author], [[longCommentModel.comments[i] reply_to] content]];
                }
            } else {
                self->_replyString = @"NOREPLY";
            }
            [self->_commentPageView.longCommentReplyTo addObject: self->_replyString];
//            NSLog(@"%@", self->_replyString);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getShortComments:self->_currentId];
        });
    } error: ^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}

- (void)getShortComments:(NSString *) currentId{
    [[Manager sharedManager] NetWorkGetShortCommentsWithData:currentId and:^(ShortCommentModel * _Nonnull shortCommentModel) {
        self->_commentPageView.shortComments = [[NSMutableArray alloc] init];
        self->_commentPageView.shortCommentAuthors = [[NSMutableArray alloc] init];
        self->_commentPageView.shortCommentHeadImages = [[NSMutableArray alloc] init];
        self->_commentPageView.shortCommentNumberOfLikes = [[NSMutableArray alloc] init];
        self->_commentPageView.shortCommentReplyTo = [[NSMutableArray alloc] init];
        self->_commentPageView.shortCommentTime = [[NSMutableArray alloc] init];
        self->_commentPageView.shortCommentShouldFold = [[NSMutableArray alloc] init];
//        NSLog(@"%@", self->_currentId);
        for (int i = 0; i < shortCommentModel.comments.count; ++i) {
            [self->_commentPageView.shortComments addObject:[shortCommentModel.comments[i] content]];
            [self->_commentPageView.shortCommentAuthors addObject:[shortCommentModel.comments[i] author]];
            [self->_commentPageView.shortCommentHeadImages addObject:[shortCommentModel.comments[i] avatar]];
            [self->_commentPageView.shortCommentNumberOfLikes addObject:[shortCommentModel.comments[i] likes]];
            [self->_commentPageView.shortCommentTime addObject:[shortCommentModel.comments[i] time]];
            [self->_commentPageView.shortCommentShouldFold addObject:@0];
            if ([shortCommentModel.comments[i] reply_to] != nil) {
                if ([[shortCommentModel.comments[i] reply_to] author] == nil || [[shortCommentModel.comments[i] reply_to] content] == nil) {
                    self->_replyString = @"抱歉，原点评已经被删除";
                } else {
                    self->_replyString = [NSString stringWithFormat:@"// %@ ：%@", [[shortCommentModel.comments[i] reply_to] author], [[shortCommentModel.comments[i] reply_to] content]];
                }
            } else {
                self->_replyString = @"NOREPLY";
            }
            [self->_commentPageView.shortCommentReplyTo addObject: self->_replyString];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_commentPageView initNumberLabel];
            [self->_commentPageView.commentTableView reloadData];
        });
    } error: ^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}

- (void)pressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
