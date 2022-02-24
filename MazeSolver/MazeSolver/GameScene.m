//
//  GameScene.m
//  MazeSolver
//
//  Created by zxiao23 on 4/15/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"



@implementation GameScene {
    SKLabelNode *_label;
    SKLabelNode *_instruction;
    SKLabelNode *_process;
    SKLabelNode *_rowLabel;
    SKLabelNode *_colLabel;
    SKLabelNode *_steps;
    
    MazeSolver *myMaze;
    int screenWidth;
    int screenHeight;
    //the following is used for the animation process
    NSMutableArray *path; //BFS
    Stack *myStack; //DFS
    bool BFS;
    bool DFS;
    int index; //BFS
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    myMaze = [[MazeSolver alloc] initWithMaze:@"smallMaze"];
    
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    _instruction = (SKLabelNode *)[self childNodeWithName:@"//instructionLabel"];
    _process = (SKLabelNode *)[self childNodeWithName:@"//processLabel"];
    _rowLabel = (SKLabelNode *)[self childNodeWithName:@"//rowLabel"];
    _colLabel = (SKLabelNode *)[self childNodeWithName:@"//colLabel"];
    _steps = (SKLabelNode *)[self childNodeWithName:@"//stepLabel"];

    //draw initializing screen
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    [self runAction:[SKAction waitForDuration:2.0]];
    _instruction.text = @"Press enter to start";
    _instruction.color = [NSColor blackColor];
    [_instruction runAction:[SKAction fadeInWithDuration:2.0]];
    
}

- (void)keyDown:(NSEvent *)theEvent {
    switch (theEvent.keyCode) {
        case 0x24 /* ENTER */:
            _instruction.text = @"Press s for small, m for medium, l for large and h for huge maze";
            break;
        case 0x01 /* s for small maze */:
            [_label runAction:[SKAction fadeOutWithDuration:0.5]];
            [_instruction runAction:[SKAction fadeOutWithDuration:0.5]];
            [myMaze updateMaze:@"smallMaze"];
            [self drawMaze];
            [self showProcessInstruc];
            break;
        case 0x2E /* m for medium maze */:
            [_label runAction:[SKAction fadeOutWithDuration:0.5]];
            [_instruction runAction:[SKAction fadeOutWithDuration:0.5]];
            [myMaze updateMaze:@"mediumMaze"];
            [self drawMaze];
            [self showProcessInstruc];
            break;
        case 0x25 /* l for large maze */:
            [_label runAction:[SKAction fadeOutWithDuration:0.5]];
            [_instruction runAction:[SKAction fadeOutWithDuration:0.5]];
            [myMaze updateMaze:@"largeMaze"];
            [self drawMaze];
            [self showProcessInstruc];
            break;
        case 0x04 /* h for huge maze */:
            //can't draw
            [_label runAction:[SKAction fadeOutWithDuration:2.0]];
            [_instruction runAction:[SKAction fadeOutWithDuration:2.0]];
            [myMaze updateMaze:@"hugeMaze"];
            [self drawMaze];
            [self showProcessInstruc];
            break;
        case 0x0B /* b for BFS */:
            //the following sets up the animation for BFS
            BFS = true;
            DFS = false;
            index = 1;
            path = [myMaze BFS]; //received a NSMutable array that has all the steps during a BFS
            //draw the start and the end nodes
            [self drawNodeAtCol:myMaze.start.col row:myMaze.start.row color:[SKColor redColor]];
            [self drawNodeAtCol:myMaze.end.col row:myMaze.end.row color:[SKColor greenColor]];
            _process.text = @"Press space for the next step.";
            break;
        case 0x02 /* d for DFS */:
            //the following sets up the animation for DFS
            BFS = false;
            DFS = true;
            myStack = [myMaze DFSinit]; //received the starting Stack for DFS for later use during the animation
            //draw the start and the end nodes
            [self drawNodeAtCol:myMaze.start.col row:myMaze.start.row color:[SKColor redColor]];
            [self drawNodeAtCol:myMaze.end.col row:myMaze.end.row color:[SKColor greenColor]];
            _process.text = @"Press space for the next step.";
            break;
        case 0x31 /* SPACE for next step */:
            if(BFS){
                GraphPoint *curP = path[index]; //path has already been set up when 'b' was pressed
                [self drawNodeAtCol:curP.col row:curP.row color:[SKColor colorWithSRGBRed:0.7803921569 green: 0.9333333333 blue:1.0 alpha:1.0]];
                [self updateLabelRow:curP.row col:curP.col step:curP.step];
                index++;
                //if we reach the end of the array
                if(index >= [path count]){
                    BFS = false;
                    NSMutableArray *shortestPath = [myMaze BFSShortestPath];
                    for(int i = 0; i < [shortestPath count]; i++){
                        GraphPoint *curP = shortestPath[i];
                        [self drawNodeAtCol:curP.col row:curP.row color:[SKColor colorWithSRGBRed:0.862745098 green: 0.6705882353 blue:1.0 alpha:1.0]];
                    }
                    [self finishInstruc];
                }
            }else if(DFS){
                NSMutableArray *curBlock = [myMaze DFSnextStep:myStack];
                GraphPoint *curP = curBlock[1];
                //the first item in the array indicated whether we are going onto a new node or deleting/ backtracking from a visited node (true = new block & false = deleting an existed block)
                if([curBlock[0] boolValue]){
                    [self drawNodeAtCol:curP.col row:curP.row color:[SKColor colorWithSRGBRed:0.7803921569 green: 0.9333333333 blue:1.0 alpha:1.0]];
                }else{
                    [self drawNodeAtCol:curP.col row:curP.row color:[SKColor lightGrayColor]];
                }
                [self updateLabelRow:curP.row col:curP.col step:curP.step];
                if(myMaze.isFinished){
                    DFS = false;
                    [self finishInstruc];
                }
            }
            break;
        case 0x08 /* c */:
            [self clearScene];
            break;
        default:
            NSLog(@"keyDown:'%@' keyCode: 0x%02X", theEvent.characters, theEvent.keyCode);
            break;
    }
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseDragged:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    
}

//this method simply draw the original unsolved maze
- (void)drawMaze{
    int blockSize = MIN(screenWidth, screenHeight)/myMaze.size;
    int curX = -screenWidth/2;
    int curY = screenHeight/2;
    for(int i = 0; i < myMaze.size; i++){
        curX = -screenWidth/2;
        for(int j = 0; j < myMaze.size; j++){
            SKShapeNode *curNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(blockSize, blockSize) cornerRadius:blockSize * 0.3];
            curNode.position = CGPointMake(curX, curY);
            if([myMaze.maze[i][j] boolValue]){
                curNode.fillColor = [SKColor lightGrayColor];
            }else{
                curNode.fillColor = [SKColor blackColor];
            }
            
            [curNode runAction:[SKAction fadeInWithDuration:2.0]];
            [self addChild:curNode];
            curX += blockSize;
        }
        curY -= blockSize;
    }
}

//draw the whole path for BFS without stopping (It is not used now)
-(void)drawPathBFS{
    NSMutableArray *path = [myMaze BFS];
    int blockSize = MIN(screenWidth, screenHeight)/myMaze.size;
    for(int i = 0; i < path.count; i++){
        SKShapeNode *curNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(blockSize, blockSize) cornerRadius:blockSize * 0.3];
        [curNode runAction:[SKAction waitForDuration:100]];
        GraphPoint *curP = path[i];
        curNode.position = CGPointMake(curP.col * blockSize - screenWidth/2, - curP.row * blockSize + screenHeight/2);
        curNode.fillColor = [SKColor darkGrayColor];
        [self addChild:curNode];
    }
}

//this method takes in current node's row, column, and color and display it on the game scene
-(void)drawNodeAtCol : (int) col row : (int) row color : (SKColor *) color{
    int blockSize = MIN(screenWidth, screenHeight)/myMaze.size;
    SKShapeNode *curNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(blockSize, blockSize) cornerRadius:blockSize * 0.3];
    [curNode runAction:[SKAction waitForDuration:100]];
    curNode.position = CGPointMake(col * blockSize - screenWidth/2, - row * blockSize + screenHeight/2);
    curNode.fillColor = color;
    [self addChild:curNode];
}

//this method clears the scene except for the instruction labels and reset the scene to the start scene. It deletes all the nodes and fade out the labels that show up during the process. Then, it shows the starting labels
-(void)clearScene{
    for(int i = [[self children] count]-1; i >= 0; i--){
        SKNode *node = [self children][i];
        if (![node.name isEqualToString:@"helloLabel"] && ![node.name isEqualToString:@"instructionLabel"] && ![node.name isEqualToString:@"processLabel"] && ![node.name isEqualToString:@"rowLabel"] && ![node.name isEqualToString:@"colLabel"] && ![node.name isEqualToString:@"stepLabel"]) {
                [node removeFromParent];
            }
    }
    [_process runAction:[SKAction fadeOutWithDuration:0.5]];
    [_rowLabel runAction:[SKAction fadeOutWithDuration:0.5]];
    [_colLabel runAction:[SKAction fadeOutWithDuration:0.5]];
    [_steps runAction:[SKAction fadeOutWithDuration:0.5]];
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    [_instruction runAction:[SKAction fadeInWithDuration:2.0]];
}

//this method shows the process instructions and row, column, and step label. It is called after the user selected a maze
-(void)showProcessInstruc{
    _process.text = @"Press 'b' for BFS and 'd' for DFS.";
    [_process runAction:[SKAction fadeInWithDuration:1.0]];
    _steps.text = @"Step: ";
    [_steps runAction:[SKAction fadeInWithDuration:1.0]];
    _rowLabel.text = @"Row: ";
    [_rowLabel runAction:[SKAction fadeInWithDuration:1.0]];
    _colLabel.text = @"Column: ";
    [_colLabel runAction:[SKAction fadeInWithDuration:1.0]];
}

//this method shows the instructions after a maze is solved.
-(void)finishInstruc{
    _process.text = @"The maze is solved! Press c for another maze.";
}

//this method takes in current row, column, and step numbers and display it on the game scene
-(void)updateLabelRow: (int) r col : (int) c step: (int) s{
    _rowLabel.text = [NSString stringWithFormat:@"Row: %d", r];
    _colLabel.text = [NSString stringWithFormat:@"Column: %d", c];
    _steps.text = [NSString stringWithFormat:@"Step: %d", s];
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
