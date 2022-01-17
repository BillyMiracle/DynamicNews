//
//  ArticleCollectionViewCell.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/25.
//

#import "ArticleCollectionViewCell.h"

@implementation ArticleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_webView];
    }
    return self;
}

@end
