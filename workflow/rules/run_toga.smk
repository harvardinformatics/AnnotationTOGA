localrules: run_toga

rule run_toga:
    input:
        chainfile='results/{}_to_{}.chain'.format(config['genome_name'],config['ref_name']),
        ref_cds_bed='results/cdsonly_{}.bed'.format(basename(config['ref_gff3']).split('.gff')[0]),
        ref_2bit='results/{}.2bit'.format(basename(config['ref_genome_fasta']).split('.fa')[0]),
        genome_2bit='results/{}.2bit'.format(basename(config['genome_fasta']).split('.fa')[0]),
    output:
        'results/toga_annotation/query_annotation.bed'
    conda:
        '../envs/toga.yml'
    params:
        toga_executable = '{}toga.py'.format(config['toga_path']),
        toga_config_dir = config['toga_config_dir'],
        cds_isoforms = config['cds_isoforms']
    shell:
        """
        {params.toga_executable} {input.chainfile} {input.ref_cds_bed} {input.ref_2bit} {input.genome_2bit} \
        --kt --pn results/toga_annotation -i {params.cds_isoforms} --nc {params.toga_config_dir} \
        --cb 10,100 --cjn 750
        """ 
