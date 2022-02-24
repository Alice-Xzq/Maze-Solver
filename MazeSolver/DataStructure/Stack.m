//
//  Stack.m
//  BFS and DFS
//
//  Created by zxiao23 on 4/15/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stack.h"

@implementation Stack

//contructor
-(instancetype)init{
    self = [super init];
    if(self){
        self.head = NULL;
    }
    return self;
}

-(instancetype)initWithHeadNode:(ListNode *)h{
    self = [super init];
    if(self){
        self.head = h;
    }
    return self;
}

-(instancetype)initWithHeadObject:(id)h{
    self = [super init];
    if(self){
        self.head = [[ListNode alloc] initWithObject:h];
    }
    return self;
}

//methods

//push an item onto the stack
-(bool)push : (id) item{
    if(!self.head){
        self.head = [[ListNode alloc] initWithObject:item];
        return true;
    }
    self.head = [[ListNode alloc] initWithObject:item andNextNode:self.head];
    return true;
}

//removes and returns the item on the top of the stack
-(id)pop{
    if(!self.head){
        return NULL;
    }
    ListNode *oldHead = self.head;
    self.head = self.head.next;
    return oldHead.object;
}

//returns the item on the top of the stack
-(id)peek{
    return self.head.object;
}

//returns true if the stack is empty, false otherwise
-(bool)isEmpty{
    if(self.head == nil){
        return true;
    }
    return false;
}

//returns the size of the stack
-(int)size{
    int count = 0;
    ListNode *cur = self.head;
    while(cur){
        cur = cur.next;
        count++;
    }
    return count;
}

//print out every element in the list
-(void)print{
    ListNode *cur = self.head;
    while(cur){
        NSLog(@"%@\n", cur.object);
        cur = cur.next;
    }
}
@end
