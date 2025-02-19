import sys
from os.path import basename
cdsisoforms = open(sys.argv[1],'r') # tab-sep table, col1 = gene, col2=isoform id
#cdsisoforms.readline()
isolist = []
for line in cdsisoforms:
    gene,isoform = line.strip().split()
    isolist.append(isoform)

bedin = open(sys.argv[2],'r')
bedout= open('results/cdsonly_{}'.format(basename(sys.argv[2])),'w')
for line in bedin:
    linelist = line.strip().split('\t')
    if linelist[3] in isolist:
        bedout.write(line)

bedout.close()
