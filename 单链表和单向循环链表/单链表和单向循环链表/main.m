//
//  main.m
//  单链表和单向循环链表
//
//  Created by 于加磊 on 2020/9/8.
//  Copyright © 2020 M了个C. All rights reserved.
//

#import <Foundation/Foundation.h>

// 自定义类型
typedef int Element;

typedef struct Node {
    // 数据域
    Element data;
    // 指针域
    struct Node *next;
}Node;

typedef Node * LinkList;


// 初始化
int initLinkList(LinkList *L) {
    // 头结点
    *L = (LinkList)malloc(sizeof(Node));
    if (*L == NULL) {
        exit(0);
    }
    // 赋值
    (*L)->next = NULL;
    (*L)->data = -1;
    
    return 1;
}

// 插入
// 前插法
void headInsert(LinkList *L, Element data) {
    // 待插入结点
    LinkList m = (LinkList)malloc(sizeof(Node));
    m->data = data;
    // 插入
    m->next = (*L)->next;
    (*L)->next = m;
}
// 后插法
void footerInsert(LinkList *L, Element data) {
    // 待插入结点
    LinkList m = (LinkList)malloc(sizeof(Node));
    m->next = NULL;
    m->data = data;
    // 尾结点
    LinkList p = *L;
    while (p->next) {
        p = p->next;
    }
    // 插入
    p->next = m;
}

// 删除
void deleteNode(LinkList *L, Element data) {
    // 判断出入数据的合法性, 这里举例判断的 -1, 因为 -1 结点给了头结点
    if (data == -1) {
        printf("要删除的结点不合法 !!! \n");
        return;
    }
    // 找到要删结点的前一个结点
    LinkList p = (*L);
    while (p->next) {
        if (p->next->data != data) {
            p = p->next;
        }else{
            break;
        }
    }
    // 判断 p 是否是要找的结点的前驱
    if (p->next == NULL) {
        printf("未找到要删除的结点!!! \n");
        return;
    }
    // 删除, 定义临时变量
    LinkList temp = p->next;
    p->next = temp->next;
    // 释放
    free(temp);
}

// 打印
void printfLinkList(LinkList L) {
    printf("要打印的链表: ");
    LinkList p = L->next;
    
    if (p == NULL) {
        printf("打印的链表为空!!!\n");
        return;
    }
    
    while (p) {
        printf("%d ", p->data);
        p = p->next;
    }
    printf("\n");
}


// 1.将 2 个递增的有序链表合并为一个递增的有序链表; 要求结果链表仍然使用两个链表的存储空间, 不另外占用其他的存储空间, 表中不允许有重复的数据
void mergeLinkLikt(LinkList *La, LinkList *Lb, LinkList *Lc) {
    LinkList pa = (*La)->next;
    LinkList pb = (*Lb)->next;
    LinkList pc;
    // 这里的 Lc 是外部传进来的空链表, 先指向 La 的头结点, 然后在 while 循环中逐步移动
    // 利用结点 pc 的移动, 将每次比较后的较小结点逐步链入进去
    *Lc = pc = *La;
    while (pa && pb) {
        if (pa->data < pb->data) {
            // 移动 pc 至小的结点 pa, 然后继续对 pc 的 next 与 pb 进行比较
            pc->next = pa;
            pc = pa;
            pa = pa->next;
        }else if (pa->data > pb->data) {
            // 移动 pc 至小的结点 pb, 然后继续对 pc 的 next 与 pa 进行比较
            pc->next = pb;
            pc = pb;
            pb = pb->next;
        }else{
            // 大小相等的情况, 按照 pa 较小的情况处理, 然后删除当前 pb 结点
            // 继续使用 pa 的 next 与 pb 的 next 执行重复步骤
            pc->next = pa;
            pc = pa;
            pa = pa->next;
            
            LinkList temp = pb;
            pb = pb->next;
            
            free(temp);
        }
    }
    // 循环结束后, 将不为空的结点的后续加点链接到链表中
    pc->next = pa ? pa : pb;
    
    free(*Lb);
}

// 2.已知 2 个链表 A 和 B 分别表示两个集合, 其元素递增排列, 合集一个算法, 用于求出 A 与 B 的交集, 并存储在 A 链表中; 例如: La = {2, 4, 6, 8}, Lb = {4, 6, 8, 10}, Lc = {4, 6, 8}
// 类似于上面第 1 道题的遍历方式
// 不同点在于, 这里只保留交集, 就是只有在相等的情况下才将结点链入表中, 其余情况直接释放
void intersectionOfLinkList(LinkList *La, LinkList *Lb, LinkList *Lc) {
    LinkList pa = (*La)->next;
    LinkList pb = (*Lb)->next;
    LinkList temp;
    LinkList pc;
    *Lc = pc = *La;
    
    while (pa && pb) {
        if (pa->data < pb->data) {
            temp = pa;
            pa = pa->next;
            free(temp);
        }else if (pa->data == pb->data) {
            pc->next = pa;
            pc = pa;
            pa = pa->next;
            
            temp = pb;
            pb = pb->next;
            free(temp);
        }else{
            temp = pb;
            pb = pb->next;
            free(temp);
        }
    }
    // 循环结束以后, 判断哪一个表还没有执行结束, 释放剩余的所有结点
    while (pa) {
        temp = pa;
        pa = pa->next;
        free(temp);
    }
    while (pb) {
        temp = pb;
        pb = pb->next;
        free(temp);
    }
    // 最后还需要将 pc 的 next 置空处理, 释放掉链表 Lb
    pc->next = NULL;
    free(*Lb);
}

// 3.设计一个算法, 将链表中所有节点的链接方向 "原地旋转", 即要求仅仅利用原表的存储空间. 换句话说, 要求算法空间复杂度为 O(1)

// 例如: L = {0, 2, 4, 6, 8, 10}, 逆转后 L = {10, 8, 6, 4, 2, 0}

void overLinkList(LinkList *La) {
    LinkList p = (*La)->next;
    LinkList q;
    (*La)->next = NULL;
    // 先将 La 头结点的指向置空
    // 通过遍历从 p 开始往下取结点
    // 然后将取出的结点通过 前插法依次插入到 La 中
    while (p) {
        q = p->next;
        p->next = (*La)->next;
        (*La)->next = p;
        p = q;
    }
}

// 4.设计一个算法, 删除递增有序链表中值大于等于 mink 且小于等于 maxk (mink, maxk 是给定的两个参数, 其值可以和表中元素相同也可以不同) 的所有元素
void clearLinkListInSection(LinkList *La, Element mink, Element maxk) {
    LinkList p = (*La)->next;
    LinkList q = (*La);
    LinkList temp;
    
    // 判断, 如果给定的 mink 和 maxk 无法构成区间, 直接 return
    // 另一种情况 因为链表为递增序列, 如果首元结点的值大于 maxk, 说明链表一定不会在该区间
    if ((mink > maxk) || (p->data > maxk)) {
        return;
    }
    // 遍历, 对出在区间中的结点进行删除, 需要注意避免链表断裂
    // 对于不在区间中的结点, 进行移位操作
    while (p) {
        if (p->data >= mink && p->data <= maxk) {
            temp = p;
            p = p->next;
            free(temp);
            continue;
        }
        q->next = p;
        q = p;
        p = p->next;
    }
    
    q->next = p;
}

// 5. 设将 n(n > 1) 个整数存放到一维数组 R 中, 试设计一个在时间和空间两方面都尽可能高效的算法; 将 R 中保存的序列循环左移 p 个位置 (0 < p < n) 个位置, 即将 R 中的数据由 (x0, x1, x2, ......, xn-1) 变换为 (xp, xp+1,......, xn-1, x0, x1,......xp-1).

// 例如: pre[10] = {0, 1, 2, 3, 4, 5,  6, 7, 8, 9}, n = 10, p = 3, pre[10] = {3, 4, 5, 6, 7, 8, 9, 0, 1, 2}

void moveLinkList(LinkList *La, int p) {
    LinkList Lb = (LinkList)malloc(sizeof(Node));
    initLinkList(&Lb);
    LinkList pb = Lb;
    
    LinkList pa = (*La)->next;
    
    // 循环遍历, 将前面的 p 个结点放入到创建的链表 Lb 中
    // 同时也要注意在 La 中将这些结点移除出去
    for (int i = 0; i < p; i++) {
        if (pa == NULL) {
            printf("p 值不合法!!!\n");
            exit(0);
        }
        pb->next = pa;
        (*La)->next = pa->next;
        pb = pa;
        pa = pa->next;
    }
    // 结束以后需要将 Lb 的尾结点, 也就是 pb 的当前结点置空, 防止错乱
    pb->next = NULL;
    
    // 找到 La 的尾结点
    while (pa->next) {
        pa = pa->next;
    }
    
    // 直接将 La 尾结点的 next 指向 Lb 的首元结点
    pa->next = Lb->next;
    // 最后将 Lb 释放掉
    Lb->next = NULL;
    free(Lb);
}

#pragma mark ---------------------非链表-------------------
// 6.已知一个整数序列 A = (a0, a1, a2,...an-1), 其中(0 <= ai <= n), (0 <= i <= n). 若存在 ap1 = ap2 = ... = apm = x, 且 m > n/2 (0 <= pk < n, 1 <= k <= m), 则称 x 为 A 的主元素. 例如: A = (0,5,5,3,5,7,5,5), 则 5 是主元素, 若 B = (0,5,5,3,5,1,5,7), 则 B 中没有主元素, 假设 A 中的 n 个元素保存在一个一位数组中, 请设计一个尽可能高效的算法, 找出数组元素中的主元素, 若存在主元素则输出该元素, 否则输出 -1。

int getMainElement(int *A, int n) {
    // 通过 count 来统计某一个元素的出现次数
    int count = 1;
    // key 为当前假设的主元素
    int key = A[0];
    // 扫描主元素
    // 因为符合主元素的条件, key 出现的次数 m 必须超过一半
    // 通过循环和判断确定数组里面可能存在主元素 key
    for (int i = 1; i < n; i++) {
        if (A[i] == key) {
            count++;
        }else{
            if (count > 0) {
                count--;
            }else{
                key = A[i];
                count = 1;
            }
        }
    }
    // 如果最后得到的 count 是 大于 0 的, 需要去重新计算一下当前 key 的出现次数
    if (count > 0) {
        count = 0;
        for (int i = 0; i < n; i++) {
            if (A[i] == key) {
                count++;
            }
        }
    }
    // 根据 count 出现的次数, 判断 key 是不是符合主元素的要求
    return (count > n/2) ? key : -1;
}

// 7.用单链表保存m个整数, 结点的结构为(data,link),且|data|<=n(n为正整数). 现在要去设计一个时间复杂度尽可能高效的算法. 对于链表中的data 绝对值相等的结点, 仅保留第一次出现的结点,而删除其余绝对值相等的结点.例如,链表A = {21,-15,15,-7,15}, 删除后的链表A={21,-15,-7};
void deleteEqualNode(LinkList *La, int n) {
    // 对链表进行非空判断
    if ((*La)->next == NULL) {
        return;
    }
    // 因为 data 里面的数 |data| <= n, 所以这里建立一个长度为 n 的 int 型数组
    int *p = alloca(sizeof(int) * n);
    // 初始化数组的值, 将值全部置空
    for (int i = 0; i < n; i++) {
        p[i] = 0;
    }
    //
    LinkList pa = (*La);
    // 对链表进行循环遍历, 在绝对值对应的下标出现时判断数组里面对应的值
    // 如果值为 0, 将其变为 1, 如果值为 1, 将后面出现的结点删除
    while (pa) {
        if (p[abs(pa->next->data)] == 1) {
            LinkList temp = pa->next;
            pa->next = pa->next->next;
            pa = pa->next;
            
            free(temp);
        }else{
            p[abs(pa->next->data)] = 1;
            pa = pa->next;
        }
    }
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        LinkList a;
        LinkList b;
        LinkList c;
        int m, n;
        
        /*
        printf("-------------初始化----------------\n");
        initLinkList(&a);
        
        printf("-------------前插法----------------\n");
        for (int i = 0; i < 5; i++) {
            printf("输入前插法要插入的数: ");
            scanf("%d", &m);
            headInsert(&a, m);
            printfLinkList(a);
        }
        printf("-------------后插法----------------\n");
        for (int i = 0; i < 5; i++) {
            printf("输入后插法要插入的数: ");
            scanf("%d", &m);
            footerInsert(&a, m);
            printfLinkList(a);
        }
        printf("-------------删除----------------\n");
        for (int i = 0; i < 5; i++) {
            printf("输入要删除的数: ");
            scanf("%d", &m);
            deleteNode(&a, m);
            printfLinkList(a);
        }
        */
        
        initLinkList(&a);
//        initLinkList(&b);
//        initLinkList(&c);
//
        printf("创建链表 a: --------------------\n");
        printf("依次输入 5 个递增的数 :\n");
        for (int i = 0; i < 5; i++) {
            scanf("%d", &m);
            footerInsert(&a, m);
        }
        printfLinkList(a);
        
//        printf("创建链表 b: --------------------\n");
//        printf("依次输入 5 个递增的数 :\n");
//        for (int i = 0; i < 5; i++) {
//            scanf("%d", &m);
//            footerInsert(&b, m);
//        }
//        printfLinkList(b);
        
        // 1.
//        printf("1. 合并后的结果为 \n");
//        mergeLinkLikt(&a, &b, &c);
//        printfLinkList(c);
        // 2.
//        printf("2. 合并后的集合结果为 \n");
//        intersectionOfLinkList(&a, &b, &c);
//        printfLinkList(c);
        // 3.
//        printf("翻转链表后的结果为: \n");
//        overLinkList(&a);
//        printfLinkList(a);
        // 4.
//        printf("删除元素后的结果为: \n");
//        printf("输入 2 个区间值: \n");
//        scanf("%d %d", &m, &n);
//        clearLinkListInSection(&a, m, n);
//        printfLinkList(a);
        // 5.
//        printf("输入左移的位数, 不能超过一位数组的最大个数: \n");
//        scanf("%d", &m);
//        moveLinkList(&a, m);
//        printfLinkList(a);
        // 6.
//        int A[] = {1,1,1,15,15,15,5,5,5,5};
//        printf("主元素为: %d\n", getMainElement(&*A, 10));
        // 7.
        printf("移除链表重复元素: \n");
        deleteEqualNode(&a, 8);
        printfLinkList(a);
    }
    return 0;
}
