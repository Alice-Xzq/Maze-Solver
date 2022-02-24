//
//  MazeSolver.h
//  MazeSolver
//
//  Created by zxiao23 on 4/15/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#ifndef MazeSolver_h
#define MazeSolver_h
#import "Point.h"
#import "Queue.h"
#import "Stack.h"

@interface MazeSolver : NSObject

@property NSMutableArray* maze;
@property NSArray* direction; //the direction array is used for determine the directions it is 4*2 with for directions that each has two values for x and y
@property int size;
@property int step;
@property bool isFinished;

@property GraphPoint* start;
@property GraphPoint* end;

//constructors
-(instancetype)initWithMaze : (NSString *) mazeName;

//methods
-(void)updateMaze : (NSString *) mazeName;
-(NSMutableArray *)BFS;
-(NSMutableArray *)BFSShortestPath;
-(void)DFS;
-(Stack *)DFSinit;
-(NSMutableArray *)DFSnextStep : (Stack *) myStack;

@end

#endif /* MazeSolver_h */
