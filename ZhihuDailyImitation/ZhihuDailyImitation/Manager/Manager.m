//
//  LatestManager.m
//  ZhihuDailyImitation
//
//  Created by 张博添 on 2021/10/17.
//


#import "Manager.h"

static Manager *manager = nil;

@implementation Manager

+ (instancetype)sharedManager {
    if(!manager) {
        //dispatch_ once _t: 使用 dispatch_once 方法能保证某段代码在程序运行过程中只被执行 1 次，并且即使在多线程的环境下，dispatch _once也可以保证线程安全。 ，用在这里就是只创建一次manger，不会创建不同的manger
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [Manager new];
        });
    }
    return manager;
}

- (void)NetWorkWithLatestData:(newsSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *json = @"http://news-at.zhihu.com/api/4/news/latest";
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:json];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            LatestModel *model = [[LatestModel alloc] initWithData:data error:nil];
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

- (void)NetWorkWithBeforeData:(NSString *)date and:(newsSucceedBlock)succeedBlock error:(errorBlock)errorBlock {
    NSString *json = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/before/%@", date];
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:json];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            LatestModel *model = [[LatestModel alloc] initWithData:data error:nil];
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

- (void)NetWorkGetLongCommentsWithData:(NSString *)a and:(SucceedLongCommentsBlock)succeedBlock error:(errorBlock)errorBlock{
    NSString *json = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/long-comments",a];
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:json];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            LongCommentModel *model = [[LongCommentModel alloc] initWithData:data error:nil];
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
//        self->_stories = country.stories[0];
//        NSLog(@"%@",self->_stories.title);
    }];
    //任务启动
    [dataTask resume];
}

- (void)NetWorkGetShortCommentsWithData:(NSString *)a and:(SucceedShortCommentsBlock)succeedBlock error:(errorBlock)errorBlock{
    NSString *json = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/short-comments",a];
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:json];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            ShortCommentModel *model = [[ShortCommentModel alloc] initWithData:data error:nil];
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

- (void)NetWorkFavoriteWithData:(NSString *)a and:(SucceedFavoriteBlock)succeedBlock error:(errorBlock)errorBlock{
    NSString *json = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@",a];
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:json];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            FavoriteModel *model = [[FavoriteModel alloc] initWithData:data error:nil];
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

- (void)NetWorkExtraWithData:(NSString *)a and:(SucceedExtraBlock)succeedBlock error:(errorBlock)errorBlock{
    NSString *json = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%@",a];
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:json];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            ExtraModel *model = [[ExtraModel alloc] initWithData:data error:nil];
            succeedBlock(model);
        } else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

@end
