localrules: create_cds_isoforms_table

rule create_cds_isoforms_table:
    input: 
        'results/cdsonly_{}'.format(basename(config['ref_gff3']))
    output:
        'results/ref_cds_isoforms.tsv'
    threads: 1
    shell:
        'python workflow/scripts/CreateCDSIsoformsTable.py {input}' 
