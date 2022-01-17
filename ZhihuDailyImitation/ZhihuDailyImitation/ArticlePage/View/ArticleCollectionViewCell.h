//
//  ArticleCollectionViewCell.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/25.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
