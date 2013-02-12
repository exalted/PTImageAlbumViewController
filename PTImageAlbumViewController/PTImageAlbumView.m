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

@interface PTImageAlbumView ()

@property (retain, nonatomic) NSMutableArray *cachedData;

@end

@implementation PTImageAlbumView

#pragma mark - Instance methods

- (NSInteger)numberOfImages
{
    if (self.cachedData == nil) {
        NSInteger numberOfImages = [self.imageAlbumDataSource numberOfImagesInAlbumView:self];
        self.cachedData = [[NSMutableArray alloc] initWithCapacity:numberOfImages];
        for (NSInteger i = 0; i < numberOfImages; i++) {
            [self.cachedData addObject:[NSMutableDictionary dictionary]];
        }
    }
    return [self.cachedData count];
}

- (CGSize)sizeForImageAtIndex:(NSInteger)index
{
    NSValue *size = [[self.cachedData objectAtIndex:index] objectForKey:@"size"];
    if (size == nil) {
        if ([self.imageAlbumDataSource respondsToSelector:@selector(imageAlbumView:sizeForImageAtIndex:)]) {
            size = [NSValue valueWithCGSize:[self.imageAlbumDataSource imageAlbumView:self sizeForImageAtIndex:index]];
        }
        else {
            NSString *source = [self sourceForImageAtIndex:index];
            
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

            // we will try to get image size from image source only if this is
            // an image file available on the file system
            if (url.isFileURL) {
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
                        
                        size = [NSValue valueWithCGSize:CGSizeMake([width floatValue], [height floatValue])];
                    }
                }
            }
        }

        [[self.cachedData objectAtIndex:index] setObject:(size ? size : [NSValue valueWithCGSize:CGSizeZero]) forKey:@"size"];
    }

    return [size CGSizeValue];
}

- (NSString *)sourceForImageAtIndex:(NSInteger)index
{
    id source = [[self.cachedData objectAtIndex:index] objectForKey:@"source"];
    if (source == nil) {
        source = [self.imageAlbumDataSource imageAlbumView:self sourceForImageAtIndex:index];
        [[self.cachedData objectAtIndex:index] setObject:(source ? source : [NSNull null]) forKey:@"source"];
    }
    return source == [NSNull null] ? nil : source;
}

- (NSString *)sourceForThumbnailImageAtIndex:(NSInteger)index
{
    id source = [[self.cachedData objectAtIndex:index] objectForKey:@"thumbnailSource"];
    if (source == nil) {
        source = [self.imageAlbumDataSource imageAlbumView:self sourceForThumbnailImageAtIndex:index];
        [[self.cachedData objectAtIndex:index] setObject:(source ? source : [NSNull null]) forKey:@"thumbnailSource"];
    }
    return source == [NSNull null] ? nil : source;
}

- (NSString *)captionForImageAtIndex:(NSInteger)index
{
    id caption = [[self.cachedData objectAtIndex:index] objectForKey:@"imageCaption"];
    if (caption == nil) {
        if ([self.imageAlbumDataSource respondsToSelector:@selector(imageAlbumView:captionForImageAtIndex:)]) {
            caption = [self.imageAlbumDataSource imageAlbumView:self captionForImageAtIndex:index];
            [[self.cachedData objectAtIndex:index] setObject:(caption ? caption : [NSNull null]) forKey:@"imageCaption"];
        }
        else {
            [[self.cachedData objectAtIndex:index] setObject:[NSNull null] forKey:@"imageCaption"];
        }
    }
    return caption == [NSNull null] ? nil : caption;
}

- (void)reloadData
{
    self.cachedData = nil;
}

@end
