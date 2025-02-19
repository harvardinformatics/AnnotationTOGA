localrules: force_psl_to_positive_strand

rule force_psl_to_positive_strand:
    input: 
        'results/genomequery2reftarget.psl'
    output:
        'results/positive_strand_genomequery2reftarget.psl'
    conda:
        '../envs/psl2_pos_target.yml'    
    threads: 1
    shell:
        'pslPosTarget {input} {output}'
              
