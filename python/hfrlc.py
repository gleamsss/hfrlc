def encoder(data):
    length_data=len(data)
    coder='' 
    count=0
    for i in range(length_data):#tqdm
        if((data[i]=='0')):
            count=count+1
        elif(data[i]!='0'):
            if(count!=0):
                s='0'+hex(count)[2:]
                len_s=len(s)
                coder=coder+'0'+s[len_s-2]+s[len_s-1]
                count=0
            coder=coder+data[i]
    if(count!=0):
        s='0'+hex(count)[2:]
        len_s=len(s)
        coder=coder+'0'+s[len_s-2]+s[len_s-1]
        count=0
    coder=coder+'000'#休止符
    return coder

if __name__ == '__main__':
    oldcode='000c6000000000000000000000000000000000000000000000000ff1600000000'
    answer=encoder(oldcode)
    print(answer)