//
//  MazeSolver.m
//  MazeSolver
//
//  Created by zxiao23 on 4/15/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MazeSolver.h"

@implementation MazeSolver

//constructors
-(instancetype)init{
    self = [super init];
    if(self){
        NSLog(@"You just created a maze without size! Please do that later!");
        self.direction = @[
                                @[ @-1, @0],
                                @[ @1, @0],
                                @[ @0, @-1],
                                @[ @0, @1],
                           ];
    }
    return self;
}

-(instancetype)initWithMaze : (NSString *) mazeName{
    self = [super init];
    if(self){
        [self updateMaze:mazeName];
        self.direction = @[
             @[ @-1, @0],
             @[ @1, @0],
             @[ @0, @-1],
             @[ @0, @1],
        ];
    }
    return self;
}

//methods
//resets the maze with a new name
-(void)updateMaze : (NSString *) mazeName{
    NSString* path = [[NSBundle mainBundle] pathForResource:mazeName ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
    encoding:NSUTF8StringEncoding
       error:NULL];
    self.maze = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
    self.size = (int)[self.maze[0] length];
    for(int i = 0; i < self.size; i++){
        NSString *row = self.maze[i];
        self.maze[i] = [[NSMutableArray alloc] initWithCapacity:self.size];
        for(int j = 0; j < self.size; j++){
            if([row characterAtIndex:j] == '.'){
                self.maze[i][j] = [NSNumber numberWithBool:YES];
            }else if([row characterAtIndex:j] == 'S'){
                self.start = [[GraphPoint alloc] initWithRow:i Col:j];
                self.maze[i][j] = [NSNumber numberWithBool:YES];
            }else if([row characterAtIndex:j] == 'G'){
                self.end = [[GraphPoint alloc] initWithRow:i Col:j];
                self.maze[i][j] = [NSNumber numberWithBool:YES];
            }else{
                self.maze[i][j] = [NSNumber numberWithBool:NO];
            }
        }
    }
//    NSLog(@"%@", self.maze);
}

//use BFS to solve the maze and returns an array that has all the steps recorded
-(NSMutableArray *)BFS{
    self.isFinished = false;
    Queue *myQueue = [[Queue alloc] initWithHeadObject:[[GraphPoint alloc] initWithRow:self.start.row Col:self.start.col]];
    self.maze[self.start.row][self.start.col] = [NSNumber numberWithBool:NO];
    NSMutableArray *path = [[NSMutableArray alloc] init];
    while(![myQueue isEmpty]){
        GraphPoint *curP = [myQueue dequeue];
        [path addObject:curP];
        NSLog(@"row: %d col:%d step:%d", curP.row, curP.col, curP.step);
        for(int i = 0; i < 4; i++){
            int newRow = curP.row + [self.direction[i][0] intValue];
            int newCol = curP.col + [self.direction[i][1] intValue];
            
            //out of limit
            if(newRow >= self.size || newCol >= self.size || newRow < 0 || newCol < 0) {
                continue;
            }
            //blocked or visited
            if(![self.maze[newRow][newCol] boolValue]){
                continue;
            }
            //end condition
            if(newRow == self.end.row && newCol == self.end.col){
                self.isFinished = true;
                NSLog(@"Finished! %d", curP.step + 1);
                self.end = [[GraphPoint alloc] initWithRow:newRow Col:newCol andStep:curP.step + 1 andPrev:curP];
                [path addObject:self.end];
                return path;
            }
            //else
            [myQueue enqueue:[[GraphPoint alloc] initWithRow:newRow Col:newCol andStep:curP.step + 1 andPrev:curP]];
            self.maze[newRow][newCol] = [NSNumber numberWithBool:NO];
        }
    }
    NSLog(@"BFS error");
    return path;
}

//returns the shortest path found by BFS
-(NSMutableArray *)BFSShortestPath{
    GraphPoint *cur = self.end;
    NSMutableArray *shortestPath = [[NSMutableArray alloc] initWithObjects:cur, nil];
    while(cur.prev){
        [shortestPath addObject:cur.prev];
        cur = cur.prev;
    }
    return shortestPath;
}

//the two following methods solve the maze with DFS by recursion
-(void)DFS{
    self.isFinished = false;
    [self DFSHelper:self.start.row :self.start.col :0];
}

-(void)DFSHelper : (int) row : (int) col : (int) step{
    NSLog(@"row: %d col: %d step : %d", row, col, step);
    //end condition
    if(row == self.end.row && col == self.end.col){
        NSLog(@"Finished at row: %d col: %d step: %d", row, col, step);
        self.step = step;
        return;
    }
    
    //recursion
    for(int i = 0; i < 4; i++){
        int newRow = row + [self.direction[i][0] intValue];
        int newCol = col + [self.direction[i][1] intValue];
        
        //out of limit
        if(newRow >= self.size || newCol >= self.size || newRow < 0 || newCol < 0) {
            continue;
        }                       
        //blocked or visited
        if(![self.maze[newRow][newCol] boolValue]){
            continue;
        }
        
        //start searching from the new point
        self.maze[newRow][newCol] = [NSNumber numberWithBool:NO];
        [self DFSHelper: newRow : newCol : step + 1];
        self.maze[newRow][newCol] = [NSNumber numberWithBool:YES];
    }
}

//the two following methods solve the maze step by step with DFS using Stack
-(Stack *)DFSinit{
    self.isFinished = false;
    Stack *myStack = [[Stack alloc] initWithHeadObject:[[GraphPoint alloc] initWithRow:self.start.row Col:self.start.col]];
    return myStack;
}

//needs the current stack
//returns the current step with a array: the first object is a indicator for whether we are going on to a new block (true) or we are backtracking from an exsited block (false), and the second object is a GraphPoint object that indicates the block
-(NSMutableArray *)DFSnextStep : (Stack *) myStack{
    GraphPoint *curP = [myStack pop];
    NSMutableArray *path = [[NSMutableArray alloc] init];
    NSLog(@"row: %d col:%d step:%d", curP.row, curP.col, curP.step);
    self.maze[self.start.row][self.start.col] = [NSNumber numberWithBool:NO];
    bool found = false;//found is for whether we found a new point we can go or not
    for(int i = 0; i < 4; i++){
        if(found){
            break;
        }
        int newRow = curP.row + [self.direction[i][0] intValue];
        int newCol = curP.col + [self.direction[i][1] intValue];
        
        //out of limit
        if(newRow >= self.size || newCol >= self.size || newRow < 0 || newCol < 0) {
            continue;
        }
        //blocked or visited
        if(![self.maze[newRow][newCol] boolValue]){
            continue;
        }
        //end condition
        if(newRow == self.end.row && newCol == self.end.col){
            NSLog(@"Finished! %d", curP.step + 1);
            self.step = curP.step + 1;
            self.isFinished = true;
            [path addObject:[NSNumber numberWithBool:true]];
            [path addObject:[[GraphPoint alloc] initWithRow:newRow Col:newCol andStep:curP.step + 1 andPrev:curP]];
            return path;
        }
        //going to a new point
        found = true;//we are finding the first avaliable direction at a time
        self.maze[newRow][newCol] = [NSNumber numberWithBool:NO];
        [myStack push:curP];
        [myStack push:[[GraphPoint alloc] initWithRow:newRow Col:newCol andStep:curP.step + 1 andPrev:curP]];
        [path addObject:[NSNumber numberWithBool:true]];
        [path addObject:[myStack peek]];
    }
    //if there is no new point (we are stuck), return the current point and backtrack
    if(!found){
        [path addObject:[NSNumber numberWithBool:false]];
        [path addObject:curP];
    }
    return path;
}



@end
