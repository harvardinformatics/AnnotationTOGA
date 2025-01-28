rule refgff3_to_genepred:
    input: 
        config['refgff3']
    output:
        '{}.genepred'.format(config['refgff3'].split('.gff')[0])
    conda:
        '../envs/gff3_to_genepred.yml'    
    threads: 1
    shell:
        'genePredToBed {input} {output}'
              