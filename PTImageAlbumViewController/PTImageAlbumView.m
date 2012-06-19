//
// Copyright (C) 2012 Ali Servet Donmez. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "PTImageAlbumView.h"

#import <ImageIO/ImageIO.h>

#import "PTImageAlbumViewDataSource.h"

@interface PTImageAlbumView () {
    NSInteger _numberOfImages;
}

@end

@implementation PTImageAlbumView

@synthesize imageAlbumDataSource = _imageAlbumDataSource;

#pragma mark - Instance methods

- (NSInteger)numberOfImages
{
    if (!_numberOfImages) {
        _numberOfImages = [self.imageAlbumDataSource numberOfImagesInAlbumView:self];
    }
    return _numberOfImages;
}

- (CGSize)sizeForImageAtIndex:(NSInteger)index
{
    if ([self.imageAlbumDataSource respondsToSelector:@selector(imageAlbumView:sizeForImageAtIndex:)]) {
        return [self.imageAlbumDataSource imageAlbumView:self sizeForImageAtIndex:index];
    }
    else {
        NSString *source = [self.imageAlbumDataSource imageAlbumView:self sourceForImageAtIndex:index];
        
        // TODO remove duplicate
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        NSURL *url = nil;
        
        // Check for file URLs.
        if ([source hasPrefix:@"/"]) {
            // If the url starts with / then it's likely a file URL, so treat it accordingly.
            url = [NSURL fileURLWithPath:source];
        }
        else {
            // Otherwise we assume it's a regular URL.
            url = [NSURL URLWithString:source];
        }
        // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
        if (imageSource) {
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache, 
                                     nil];
            
            CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (__bridge CFDictionaryRef)options);
            CFRelease(imageSource);

            if (imageProperties) {
                NSNumber *width = (__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
                NSNumber *height = (__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
                CFRelease(imageProperties);
                
                return CGSizeMake([width floatValue], [height floatValue]);
            }
        }
    }
    
    return CGSizeZero;
}

- (NSString *)sourceForImageAtIndex:(NSInteger)index
{
    return [self.imageAlbumDataSource imageAlbumView:self sourceForImageAtIndex:index];
}

- (NSString *)sourceForThumbnailImageAtIndex:(NSInteger)index
{
    return [self.imageAlbumDataSource imageAlbumView:self sourceForThumbnailImageAtIndex:index];
}

@end
