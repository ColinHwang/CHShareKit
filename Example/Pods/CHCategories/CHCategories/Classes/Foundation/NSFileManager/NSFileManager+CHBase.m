//
//  NSFileManager+CHBase.m
//  CHCategories
//
//  Created by CHwang on 17/1/4.
//

#import "NSFileManager+CHBase.h"

@implementation NSFileManager (CHBase)

#pragma mark - Base
- (int64_t)ch_fileSizeWithPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL exists = [self fileExistsAtPath:path isDirectory:&isDirectory];
    if (exists == NO) return -1;
    
    if (!isDirectory)  {
        NSDictionary *attributes = [self attributesOfItemAtPath:path error:nil];
        return [attributes[NSFileSize] unsignedLongLongValue];
    }
    
    int64_t totalByteSize = 0;
    NSDirectoryEnumerator *enumerator = [self enumeratorAtPath:path];
    
    for (NSString *subpath in enumerator) {
        NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
        BOOL isDirectory = NO;
        [self fileExistsAtPath:fullSubpath isDirectory:&isDirectory];
        
        if (!isDirectory) {
            NSDictionary *attributes = [self attributesOfItemAtPath:fullSubpath error:nil];
            totalByteSize += [attributes[NSFileSize] unsignedLongLongValue];
        }
    }
    return totalByteSize;
}

@end
