rule create_chain_file:
    input:
        psl='results/positive_strand_genomequery2reftarget.psl',
        ref_2bit='results/{}.2bit'.format(basename(config['ref_genome_fasta']).split('.fa')[0]),
        genome_2bit='results/{}.2bit'.format(basename(config['genome_fasta']).split('.fa')[0])
    output:
       'results/{}_to_{}.chain'.format(config['genome_name'],config['ref_name']) 
    conda:
        '../envs/axtchain.yml'
    threads: 1
    shell:
        """
        axtChain -psl -verbose=0 -linearGap=loose {input.psl} {input.ref_2bit} {input.genome_2bit} {output}
        """ 
