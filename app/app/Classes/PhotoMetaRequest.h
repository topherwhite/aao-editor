//
//  PhotoMetaRequest.h
//  AAOEditor
//
//  Created by Antony Harfield on 04/09/2010.
//  Copyright 2010 againstallodds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericRequest.h"
#import "Photo.h"


@protocol LoadedPhotoMetaDelegate
- (void)didLoadPhotoMeta:(Photo *)photo;
@end


@interface PhotoMetaRequest : GenericRequest {

	id<LoadedPhotoMetaDelegate> delegate;
	
}

- (id)initWithDelegate:(id<LoadedPhotoMetaDelegate>)delegate;

@property(nonatomic, assign) id<LoadedPhotoMetaDelegate> delegate;

@end
