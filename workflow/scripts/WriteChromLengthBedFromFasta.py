import sys
from Bio import SeqIO
chrombed = open('results/chromosome_lengths.bed','w')

for record in SeqIO.parse(sys.argv[1], "fasta"):
    chrombed.write('%s\t0\t%s\n' % (record.id,len(record.seq)))

chrombed.close()
