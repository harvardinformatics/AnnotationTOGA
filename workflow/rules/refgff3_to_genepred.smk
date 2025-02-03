localrules: refgff3_to_genepred

rule refgff3_to_genepred:
    input: 
        config['ref_gff3']
    output:
        'results/{}.genepred'.format(basename(config['ref_gff3']).split('.gff')[0])
    conda:
        '../envs/gff3_to_genepred.yml'    
    threads: 1
    shell:
        'genePredToBed {input} {output}'
              
