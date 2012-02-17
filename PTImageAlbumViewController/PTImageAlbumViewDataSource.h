//
//  PTImageAlbumViewDataSource.h
//  AlbumDemo
//
//  Created by Ali Servet Donmez on 17.2.12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTImageAlbumView;

@protocol PTImageAlbumViewDataSource <NSObject>

@required
- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView;
- (UIImage *)imageAlbumView:(PTImageAlbumView *)imageAlbumView imageAtIndex:(NSInteger)index;

@end
