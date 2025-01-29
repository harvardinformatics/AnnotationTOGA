rule create_2bits_from_genomes:
    input:
        ref=config['ref_fasta']
        genome=config['genome_fasta']
    output:
        ref_2bit='{}.2bit'.format(config['ref_fasta'].split('.fa')[0])
        genome_2bit={}.2bit'.format(config['genome_fasta'].split('.fa')[0])
    conda:
        '../envs/fa_to_2bit.yml'
    threads: 1
    shell:
        """
        faToTwoBit {input.ref} {output.ref_2bit}
        faToTwoBit {input.genome} {output.genome_2bit}
        """
    

        
