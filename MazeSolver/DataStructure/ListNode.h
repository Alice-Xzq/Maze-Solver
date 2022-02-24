//
//  ListNode.h
//  BFS and DFS
//
//  Created by zxiao23 on 4/15/21.
//  Copyright © 2021 zxiao23. All rights reserved.
//

#ifndef ListNode_h
#define ListNode_h

@interface ListNode<ObjectType> : NSObject

@property ObjectType object;

@property ListNode *next;

-(instancetype)initWithObject:(ObjectType)object;

-(instancetype)initWithObject:(ObjectType)object andNextNode:(ListNode *)node;

@end

#endif /* ListNode_h */
