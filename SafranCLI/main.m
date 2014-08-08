//
//  main.m
//  SafranCLI
//
//  Created by Said on 08/08/2014.
//
//

#import <Foundation/Foundation.h>
#import "SCParser.h"
#define RSSURL @"http://www.safran.io/feed.rss"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        SCParser *parser = [[SCParser alloc] initWithURL:RSSURL];
        [parser parse];
    }
    return 0;
}

