//
//  LongCommentModel.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/29.
//

#import "LongCommentModel.h"

@implementation LongReplyModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}

@end

@implementation LCommentModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation LongCommentModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
