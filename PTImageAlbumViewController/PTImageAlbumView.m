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

#import "PTImageAlbumViewDataSource.h"

@interface PTImageAlbumView ()

@property (nonatomic, retain) NSMutableArray *data;

@end

@implementation PTImageAlbumView

@synthesize imageAlbumDataSource = _imageAlbumDataSource;

// private
@synthesize data = _data;

#pragma mark - Instance methods

- (NSInteger)numberOfImages
{
    return [self.data count];
}

- (CGSize)sizeForImageAtIndex:(NSInteger)index
{
    return [[[self.data objectAtIndex:index] objectForKey:@"size"] CGSizeValue];
}

- (UIImage *)imageAtIndex:(NSInteger)index
{
    id object = [[self.data objectAtIndex:index] objectForKey:@"image"];
    return object == [NSNull null] ? nil : object;
}

- (UIImage *)thumbnailImageAtIndex:(NSInteger)index
{
    id object = [[self.data objectAtIndex:index] objectForKey:@"thumbnailImage"];
    return object == [NSNull null] ? nil : object;
}

- (NSString *)sourceForImageAtIndex:(NSInteger)index
{
    id object = [[self.data objectAtIndex:index] objectForKey:@"source"];
    return object == [NSNull null] ? nil : object;
}

- (NSString *)sourceForThumbnailImageAtIndex:(NSInteger)index
{
    id object = [[self.data objectAtIndex:index] objectForKey:@"thumbnailImageSource"];
    return object == [NSNull null] ? nil : object;
}

- (void)reloadData
{
    // Ask data source for number of images
    NSInteger numberOfImages = [self.imageAlbumDataSource numberOfImagesInAlbumView:self];
    
    // Create an images' info array for reusing
    self.data = [NSMutableArray arrayWithCapacity:numberOfImages];
    for (NSInteger i = 0; i < numberOfImages; i++) {
        // Ask data source for image size
        CGSize size = [self.imageAlbumDataSource imageAlbumView:self sizeForImageAtIndex:i];
        
        // Ask data source for image and thumbnail image
        UIImage *image = [self.imageAlbumDataSource imageAlbumView:self imageAtIndex:i];
        UIImage *thumbnailImage = [self.imageAlbumDataSource imageAlbumView:self thumbnailImageAtIndex:i];
        
        // If image is nil, ask data source where to get it
        NSString *source;
        if (!image) {
            source = [self.imageAlbumDataSource imageAlbumView:self sourceForImageAtIndex:i];
            NSAssert(source, @"cannot show image since you didn't neither returned it nor told us where to get it.");
        }

        // If thumbnail image is nil, ask data source where to get it
        NSString *thumbnailImageSource;
        if (!thumbnailImage) {
            thumbnailImageSource = [self.imageAlbumDataSource imageAlbumView:self sourceForThumbnailImageAtIndex:i];
            NSAssert(thumbnailImageSource, @"cannot thumbnail show image since you didn't neither returned it nor told us where to get it.");
        }
        
        [self.data addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                              [NSValue valueWithCGSize:size], @"size",
                              image ? image : [NSNull null], @"image",
                              thumbnailImage ? thumbnailImage : [NSNull null], @"thumbnailImage",
                              source ? source : [NSNull null], @"source",
                              thumbnailImageSource ? thumbnailImageSource : [NSNull null], @"thumbnailImageSource",
                              nil]];
    }
}

@end
