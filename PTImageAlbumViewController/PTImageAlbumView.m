//
// Copyright (C) 2012 Ali Servet Donmez. All rights reserved.
//
// This file is part of PTImageAlbumViewController.
// modify it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// PTImageAlbumViewController is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with PTImageAlbumViewController. If not, see <http://www.gnu.org/licenses/>.
// PTImageAlbumViewController is free software: you can redistribute it and/or
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
