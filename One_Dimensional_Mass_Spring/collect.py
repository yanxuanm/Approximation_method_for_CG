import sys

first_arg = sys.argv[1]

second_arg = sys.argv[2]

def findcorr(eqt=first_arg, sub=second_arg):
	if sub == "E^1":
		sub="E"
	index = eqt.rfind(sub)
	res = ""
	pa = 0
	if sub == "E^0":
		eqsign = eqt.find("==")
		lste = eqt.rfind("E")
		temp = eqt[lste:eqsign]
		spc = temp.find(" ")
		temp = temp[spc+3:]
		return temp+" == 0"
	for i in range(index-2,-1,-1):
		c = eqt[i]
		if c==' ' and pa==0:
			if res=="":
				res = "1"
			return res+" == 0"

		if c==")":
			pa+=1
		if c=="(":
			pa-=1
		res = c+res
	if res=="":
		res = "1"
	return res+" == 0"
print(findcorr(first_arg,second_arg))
