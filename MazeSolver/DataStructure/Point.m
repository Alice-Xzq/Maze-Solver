//
//  Point.m
//  BFSandDFS
//
//  Created by zxiao23 on 4/15/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point.h"

@implementation GraphPoint

//constructor
-(instancetype)init{
    self = [super init];
    if(self){
        self.row = -1;
        self.col = -1;
        self.step = 0;
        NSLog(@"You init a Point without setting its x and y, please make sure you do so");
    }
    return self;
}

-(instancetype)initWithRow : (int) rowInt Col : (int) colInt{
    self = [super init];
    if(self){
        self.row = rowInt;
        self.col = colInt;
        self.step = 0;
    }
    return self;
}

-(instancetype)initWithRow : (int) rowInt Col : (int) colInt andStep : (int) stepInt{
    self = [super init];
    if(self){
        self.row = rowInt;
        self.col = colInt;
        self.step = stepInt;
    }
    return self;
}

-(instancetype)initWithRow : (int) rowInt Col : (int) colInt andStep : (int) stepInt andPrev : (GraphPoint *) p{
    self = [super init];
    if(self){
        self.row = rowInt;
        self.col = colInt;
        self.step = stepInt;
        self.prev = p;
    }
    return self;
}

@end

