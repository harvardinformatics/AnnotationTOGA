rule refgenepred_to_bed:
    input: 
        '{}.genepred'.format(config['refgff3'].split('.gff')[0])
    output:
        '{}.bed'.format(config['refgff3'].split('.gff')[0])
    conda:
        '../envs/refgenepred_to_bed.yml'    
    threads: 1
    shell:
        'genePredToBed {input} {output}'
              