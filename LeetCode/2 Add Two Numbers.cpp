/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */
class Solution {
public:
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        ListNode* i2=l2;
        ListNode* t=l2;
        char c = 0;
        while (l1||i2||c){
            c+=(l1?l1->val:0)+(i2?i2->val:0);
            if (i2) {
                i2->val=c%10;
            }else{
                i2=new ListNode(c%10);
                t->next=i2;
            }
            c/=10;
            l1=l1?l1->next?l1->next:nullptr:nullptr;
            t=i2;
            i2=i2?i2->next?i2->next:nullptr:nullptr;
        }
        return l2;
    }
};