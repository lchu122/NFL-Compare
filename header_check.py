with open('headers.csv', 'rb') as f:
    lines = f.readlines()



    k = []
    for line in lines:
        a = set(line.split(','))
        print len(a)
        k.append(a)

    init = k[0].intersection(k[1])
    for i in range(2, len(k)):
        init = init.intersection(k[i])


    for l in range(len(k)):
        print k[l] - init




