localrules: filtered_togabed_to_gtf

rule filtered_togabed_to_gtf:
    input: 
        'results/toga_annotation/filtered_query_annotation.bed'
    output:
        'results/toga_annotation/filtered_query_annotation.gtf'
    conda:
        '../envs/filtered_togabed_to_gtf.yml'    
    threads: 1
    shell:
        """
        bedToGenePred {input} results/toga_annotation/filtered_query_annotation.genepred
        genePredToGtf file results/toga_annotation/filtered_query_annotation.genepred {output}
        """
              
