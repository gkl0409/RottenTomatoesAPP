//
//  RottenTomatoesUtil.h
//  RottenTomatoesAPP
//
//  Created by kaden Chiang on 2015/6/15.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RottenTomatoesUtil : NSObject

+ (void)callMoviesAPIWithType: (NSString *)type limit: (NSInteger)limit onComplete:(void (^)(NSData *data, NSError *error))completionHandler;

+(NSString *)hiResImageUrl: (NSString *) resizedImgUrl;
@end
