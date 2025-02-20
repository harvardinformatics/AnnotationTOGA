import argparse
from os.path import basename

if __name__=="__main__": 
    parser = argparse.ArgumentParser(description="filter TOGA annotation bed file so only keeps classified orthologs")
    parser.add_argument('-orthtable','--orthology-classification-table',dest='orthos',type=str,help='orthology classification toga file')
    parser.add_argument('-bedin','--query-annotation-bed',dest='annotbed',type=str,help='query_annotation.bed toga file')
    opts = parser.parse_args()

    orthology = open(opts.orthos,'r')
    orthology.readline()
    orthoset = set()
    for line in orthology:
        linelist = line.strip().split('\t')
        orthoset.add(linelist[3])

    no_ortho_counter = 0
    bedopen = open(opts.annotbed,'r')
    bedout = open('results/toga_annotation/filtered_%s' % basename(opts.annotbed),'w')
    for line in bedopen:
        linelist = line.strip().split('\t')
        if linelist[3] in orthoset:
            bedout.write(line)

    bedout.close()
