//
//  LatestModel.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/17.
//

#import "LatestModel.h"

@implementation Top_StoriesModel
//+ (BOOL)propertyIsOptional:(NSString *)propertyName 作用是不想因为服务器的某个值没有返回(nil)就使程序崩溃， 可以加关键字Optional，如果不想每一条属性都添加，也可以在.m文件中重写方法
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation StoriesModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation LatestModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
