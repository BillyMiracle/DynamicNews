//
//  ExtraModel.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/11/7.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExtraModel : JSONModel

@property (nonatomic, copy) NSString *long_comments;
@property (nonatomic, copy) NSString *popularity;
@property (nonatomic, copy) NSString *short_comments;
@property (nonatomic, copy) NSString *comments;

@end

NS_ASSUME_NONNULL_END
