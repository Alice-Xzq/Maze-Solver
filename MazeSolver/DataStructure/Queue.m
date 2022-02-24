//
//  Queue.m
//  BFS and DFS
//
//  Created by zxiao23 on 4/15/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Queue.h"
#import "ListNode.h"

@implementation Queue

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

//return the last node of the queue.
-(ListNode *)last{
    ListNode *cur = self.head;
    while(cur && cur.next){
        cur = cur.next;
    }
    return cur;
}

//push an item onto the queue
-(bool)enqueue : (id) item{
    if(!self.head){
        self.head = [[ListNode alloc] initWithObject:item];
        return true;
    }
    [self last].next = [[ListNode alloc] initWithObject:item];
    return true;
}

-(bool)enqueueWithNode : (ListNode *) node{
    if(!self.head){
        self.head = node;
        return true;
    }
    [self last].next = node;
    return true;
}

//removes and returns the item on the top of the queue
-(id)dequeue{
    ListNode *node = self.head;
    if(self.head){
        self.head = self.head.next;
    }
    return node.object;
}

-(ListNode *)dequeueWithNode{
    ListNode *node = self.head;
    if(self.head){
        self.head = self.head.next;
    }
    node.next = NULL;
    return node;
}

//returns the item on the top of the queue
-(id)peek{
    return self.head.object;
}

//returns true if the queue is empty, false otherwise
-(bool)isEmpty{
    if(self.head){
        return false;
    }
    return true;
}

//returns the size of the queue
-(int)size{
    int count = 0;
    ListNode *cur = self.head;
    while(cur){
        cur = cur.next;
        count++;
    }
    return count;
}

//print out every element in the queue
-(void)print{
    ListNode *cur = self.head;
    while(cur){
        NSLog(@"%@\n", cur.object);
        cur = cur.next;
    }
}

@end
