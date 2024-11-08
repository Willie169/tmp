a="https://en.wikipedia.org/wiki/Arbitrage_pricing_theory"
data=[]
url=[]
while 1:
    n=input()
    if n=="0":
        break
    url.append(n)
    n=n[30::]
    n=n.replace("_", " ")
    data.append(n)
for i in range(0, len(data)):
    print("Wikipedia. (n.d.). ", data[i], ". Wikipedia. ", url[i], sep="")