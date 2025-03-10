rule extract_psl_from_cactus_hal:
    input:
        halfile=config['cactus_hal'],
        chrom_lengths='results/chromosome_lengths.bed' 
    output:
        'results/genomequery2reftarget.psl'  
    #container:
        #'docker://quay.io/comparative-genomics-toolkit/cactus:v2.2.0-gpu'
    params:
        query_name=config['genome_name'],
        target_ref_name=config['ref_name']
    singularity:
        "docker://quay.io/comparative-genomics-toolkit/cactus:v2.9.3"
    shell:
        """
        halLiftover --outPSL {input.halfile}  {params.query_name} \
        {input.chrom_lengths} {params.target_ref_name} {output} 
        """


  
