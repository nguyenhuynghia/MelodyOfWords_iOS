//
//  Service.m
//  App
//
//  Created by HBLab-NghiaNH on 7/30/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "Service.h"
#import "FileEntity.h"
#import "Constants.h"
#import "NSDate+Utility.h"

@implementation Service
- (void)getMidiFileWithPrimer:(NSArray *)primer completeHandle: (ServerResponseHandler)completion {
    NSString *api_path = [NSString stringWithFormat:@"%@%@", API_ROOT_URL, API_PATH_GET_MIDI_FILE];
    if (primer.count == 0) {
        return;
    }
    NSString *query = [NSString stringWithFormat:@"?primer=[%@]", [primer componentsJoinedByString:@","]];
    NSString *url = [NSString stringWithFormat:@"%@%@", api_path, query];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *fileName = [NSString stringWithFormat:@"%@.mid", [NSDate dateToString:[NSDate date] format:@"YYYYMMDD_HHmmss"]];
            NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* docsDir = [dirPaths objectAtIndex:0];
            NSString *filePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:fileName]];
            if (data != nil) {
                [data writeToFile:filePath atomically:YES];
                
                FileEntity *entity = [FileEntity new];
                entity.fileName = fileName;
                entity.filePath = filePath;
                if (completion) {
                    completion(YES, entity);
                }
            }
        });
    });
}
@end

