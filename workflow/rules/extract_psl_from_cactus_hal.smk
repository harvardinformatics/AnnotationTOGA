rule extract_psl_from_cactus_hal:
    input:
        halfile=config['cactus_hal']
        query_genome=config['genome_fasta']
        target_ref_genome=config['ref_genome_fasta']
        chrom_lengths='chromosome_lengths.bed' 
    output:
        'genomequery2reftarget.psl'  
    container:
        'docker://quay.io/comparative-genomics-toolkit/cactus:v2.2.0-gpu'
    shell:
        """
        halLiftover --outPSL {input.hal}  {input.query_genome} \
        {input.chrom_lengths} ${target_ref_genome} {output} 
        """


  
