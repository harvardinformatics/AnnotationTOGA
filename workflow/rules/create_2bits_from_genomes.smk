rule create_2bits_from_genomes:
    input:
        ref=config['ref_fasta']
        target=config['target_fasta']
    output:
        ref_2bit='{}.2bit'.format(config['ref_fasta'].split('.fa')[0])
        target_2bit={}.2bit'.format(config['target_fasta'].split('.fa')[0])
    conda:
        '../envs/fa_to_2bit.yml'
    threads: 1
    shell:
        """
        faToTwoBit {input.ref} {output.ref_2bit}
        faToTwoBit {input.target} {output.target_2bit}
    

        
