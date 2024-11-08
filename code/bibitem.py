ms = """This is line 1
This is line 2
This is line 3"""
ll = ms.splitlines()
for i, t in enumerate(ll):
    ll[i] = "\\bibitem{" + str(i+1) + "} " + t
print('\n'.join(ll))