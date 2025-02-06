localrules: create_cdsonly_gff3

rule create_cdsonly_gff3:
    input: 
        config['ref_gff3']
        #refgenome=config['ref_genome_fasta']
    output:
        'results/cdsonly_{}'.format(basename(config['ref_gff3']))
    conda:
        '../envs/gffread.yml'
    threads: 1
    shell:
        """
        #gffread {input} > results/refgenome.gff3 
        #awk -F'\\t' '$7 != "?" && $7 != "."' results/refgenome.gff3 > results/refcleaned.gff3
        gffread {input} -F -C -o {output}
        #gffread results/refcleaned.gff3 -F -C -o {output}
        #rm results/refgenome.gff3
        #rm results/refcleaned.gff3
        """      
