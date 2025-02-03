localrules: refgenepred_to_bed

rule refgenepred_to_bed:
    input: 
        'results/{}.genepred'.format(basename(config['ref_gff3']).split('.gff')[0])
    output:
        'results/{}.bed'.format(basename(config['ref_gff3']).split('.gff')[0])
    conda:
        '../envs/refgenepred_to_bed.yml'    
    threads: 1
    shell:
        'genePredToBed {input} {output}'
              
