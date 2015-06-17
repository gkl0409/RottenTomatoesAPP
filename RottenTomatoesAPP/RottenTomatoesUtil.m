//
//  RottenTomatoesUtil.m
//  RottenTomatoesAPP
//
//  Created by kaden Chiang on 2015/6/15.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "RottenTomatoesUtil.h"

@implementation RottenTomatoesUtil


+ (void)callAPIWithType: (NSString *)type subtype:(NSString *)subtype limit: (NSInteger)limit onComplete:(void (^)(NSData *data, NSError *error))completionHandler {
    // type box_office

    NSString *urlString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/%@/%@.json?limit=%ld&country=us&apikey=dagqdghwaq3e3mxyrp7kmmj5", type, subtype, limit];

    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
        if (completionHandler != nil) {
            completionHandler(data, error);
        }
    }];
}

+ (NSString *)hiResImageUrl: (NSString *) resizedImgUrl {
    if (resizedImgUrl == nil)
        return nil;
    NSArray *imgUrlToken = [resizedImgUrl componentsSeparatedByString:@"/"];
    NSLog(@"token: %@", imgUrlToken);
    
    NSInteger rangeLocation= 0;
    NSInteger rangeLength = [imgUrlToken count];
    for (NSInteger i=0; i< [imgUrlToken count]; i++) {
        NSRange match = [imgUrlToken[i] rangeOfString:@"cloudfront.net"];
        if (match.location != NSNotFound) {
            rangeLocation = i;
            rangeLength = rangeLength - i;
            break;
        }
    }
    imgUrlToken = [imgUrlToken subarrayWithRange: NSMakeRange(rangeLocation, rangeLength) ];
    imgUrlToken = [[NSArray arrayWithObject:@"http:/"] arrayByAddingObjectsFromArray:imgUrlToken];
    return [imgUrlToken componentsJoinedByString:@"/"];
}

@end
