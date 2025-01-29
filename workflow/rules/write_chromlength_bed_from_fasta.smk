rule write_chromlength_bed:
    input:
        config['ref_genome_fasta']
    output:    
        'chromosome_lengths.bed'
    conda:
        '../envs/biopython.yml'
    threads: 1    
    script:
        '../scripts/WriteChromLengthBedFromFasta.py'
    