//
//  FavoriteModel.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/31.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteModel : JSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;

@end

NS_ASSUME_NONNULL_END
