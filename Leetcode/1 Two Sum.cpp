class Solution
{
  public:
	vector<int> twoSum(vector<int> &nums, int target)
	{
		vector<int> r;
		r=sort(nums.begin(), nums.end());
		int *s = &nums[0];
		int *e = &nums[nums.size() - 1];
		while (1)
		{
			if (s[0] + e[0] == target)
			{
				r.push_back();
				r.push_back();
				return r;
			}
			else if (s[0] + e[0] < target)
			{
				s = &s[1];
			}
			else
			{
				e = &e[-1];
			}
		}
	}
};