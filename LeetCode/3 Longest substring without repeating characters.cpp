class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        int maxlen = 0;
        int start = 0;
        unordered_set<char> charSet;
        for (int pos = 0; pos < s.size(); pos++) {
            while (charSet.find(s[pos]) != charSet.end()) {
                charSet.erase(s[start]);
                start++;
            }
            charSet.insert(s[pos]);
            maxlen = max(maxlen, pos - start + 1);
        }
        return maxlen;
    }
};