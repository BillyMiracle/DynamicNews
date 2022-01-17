//
//  ShortCommentModel.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/29.
//

#import "ShortCommentModel.h"

@implementation ShortReplyModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

@implementation SecondCommentModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation ShortCommentModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
