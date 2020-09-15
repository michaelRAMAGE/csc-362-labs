with open('fix.txt', 'r') as f, open('fix_out.txt', 'w') as wo:
    for line in f:
        line = line.strip().split(',')
        start = line[0:2]
        end = line[2:]
        wo.write(','.join(start))
        for d in end:
            wo.write(',')
            if d != 'null':
                d = d.split("/")
                new_date = d[2]+'-'+d[0]+'-'+d[1]
                wo.write(f'"{new_date}"')
            else:
                wo.write(f'null')
        wo.write('\n')        
            
