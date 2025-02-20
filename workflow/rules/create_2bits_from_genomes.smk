localrules: create_2bits_from_genomes

rule create_2bits_from_genomes:
    input:
        ref=config['ref_genome_fasta'],
        genome=config['genome_fasta']
    output:
        ref_2bit='results/{}.2bit'.format(basename(config['ref_genome_fasta']).split('.fa')[0]),
        genome_2bit='results/{}.2bit'.format(basename(config['genome_fasta']).split('.fa')[0])
    conda:
        '../envs/fa_to_2bit.yml'
    threads: 1
    shell:
        """
        faToTwoBit {input.ref} {output.ref_2bit}
        faToTwoBit {input.genome} {output.genome_2bit}
        """
    

        
