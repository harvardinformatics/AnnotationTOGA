localrules: create_cdsonly_gff3

rule create_cdsonly_gff3:
    input: 
        gff3=config['ref_gff3'],
        refgenome=config['ref_genome_fasta']
    output:
        'results/cdsonly_{}'.format(basename(config['ref_gff3']))
    conda:
        '../envs/gffread.yml'    
    threads: 1
    shell:
        'gffread {input.gff3} -g {input.refgenome} -F -C -o {output}'
              
