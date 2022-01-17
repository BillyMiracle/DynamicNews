//
//  LongCommentModel.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/29.
//

@protocol LCommentModel
@end
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LongReplyModel : JSONModel
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long status;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *error_msg;
@end

@interface LCommentModel : JSONModel
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic, copy) LongReplyModel *reply_to;
@end

@interface LongCommentModel : JSONModel
@property (nonatomic, copy) NSArray<LCommentModel> *comments;
@end

NS_ASSUME_NONNULL_END
