//
//  PTImageAlbumView.h
//  AlbumDemo
//
//  Created by Ali Servet Donmez on 17.2.12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

#import "NIPhotoAlbumScrollView.h"

@protocol PTImageAlbumViewDataSource;

@interface PTImageAlbumView : NIPhotoAlbumScrollView

@property(nonatomic, assign) id<PTImageAlbumViewDataSource> imageAlbumDataSource;

@end
