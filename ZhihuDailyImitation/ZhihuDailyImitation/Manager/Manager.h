//
//  LatestManager.h
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/17.
//

#import <Foundation/Foundation.h>
#import "LatestModel.h"
#import "LongCommentModel.h"
#import "ShortCommentModel.h"
#import "FavoriteModel.h"
#import "ExtraModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Manager : NSObject

//这样就可以利用 SuccesBlock进行参数的传递或者是编辑。
typedef void (^newsSucceedBlock)(LatestModel * _Nonnull mainViewNowModel);
typedef void (^SucceedLongCommentsBlock)(LongCommentModel * _Nonnull mainViewNowModel);
typedef void (^SucceedShortCommentsBlock)(ShortCommentModel * _Nonnull mainViewNowModel);
typedef void (^SucceedFavoriteBlock)(FavoriteModel * _Nonnull mainViewNowModel);
typedef void (^SucceedExtraBlock)(ExtraModel * _Nonnull mainViewNowModel);

//失败返回error
typedef void (^errorBlock)(NSError * _Nonnull error);

+ (instancetype)sharedManager;

- (void)NetWorkWithLatestData:(newsSucceedBlock) succeedBlock error:(errorBlock) errorBlock;
- (void)NetWorkWithBeforeData:(NSString*)data and:(newsSucceedBlock)succeedBlock error:(errorBlock)errorBlock;
- (void)NetWorkGetLongCommentsWithData:(NSString *)a and:(SucceedLongCommentsBlock)succeedBlock error:(errorBlock)errorBlock;
- (void)NetWorkGetShortCommentsWithData:(NSString *)a and:(SucceedShortCommentsBlock)succeedBlock error:(errorBlock)errorBlock;
- (void)NetWorkFavoriteWithData:(NSString *)a and:(SucceedFavoriteBlock)succeedBlock error:(errorBlock)errorBlock;
- (void)NetWorkExtraWithData:(NSString *)a and:(SucceedExtraBlock)succeedBlock error:(errorBlock)errorBlock;

@end

NS_ASSUME_NONNULL_END
