//
//  Point.h
//  BFSandDFS
//
//  Created by zxiao23 on 4/15/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#ifndef Point_h
#define Point_h

@interface GraphPoint : NSObject

@property int row;
@property int col;
@property int step;
@property GraphPoint *prev;

//constructor
-(instancetype)initWithRow : (int) rowInt Col : (int) colInt;
-(instancetype)initWithRow : (int) rowInt Col : (int) colInt andStep : (int) stepInt;
-(instancetype)initWithRow : (int) rowInt Col : (int) colInt andStep : (int) stepInt andPrev : (GraphPoint *) p;

@end

#endif /* Point_h */
