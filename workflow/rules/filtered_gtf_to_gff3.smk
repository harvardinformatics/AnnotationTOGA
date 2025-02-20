localrules: filtered_gtf_to_gff3

rule filtered_gtf_to_gff3:
    input: 
        'results/toga_annotation/filtered_query_annotation.gtf'
    output:
        'results/toga_annotation/filtered_query_annotation.gff3'
    conda:
        '../envs/gffread.yml'    
    threads: 1
    shell:
        """
        gffread {input} -o {output}
        """
              
