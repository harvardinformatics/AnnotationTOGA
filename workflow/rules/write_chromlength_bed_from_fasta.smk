rule write_chromlength_bed:
    input:
        config['genomefasta']
    output:    
        'chromosome_lengths.bed'
    conda:
        '../envs/biopython.yaml'
    threads: 1    
    script:
        '../scripts/WriteChromLengthBedFromFasta.py'
    