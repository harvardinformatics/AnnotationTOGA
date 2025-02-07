localrules: create_cds_isoforms_table

rule create_cds_isoforms_table:
    input: 
        'results/cdsonly_{}'.format(basename(config['ref_gff3']))
    output:
        'results/ref_cds_isoforms.tsv'
    threads: 1
    shell:
        """
        awk -F"\t" '$3=="mRNA"{{print $9}}' {input} | \
        awk -F";" '{{print $2"\t"$1}}' |sed 's/\tID=/ /g' | \
        sed 's/gene-//g' |sed 's/rna-//g' | \
        awk -F"=" '{{print $2}}' > {output}
        """ 
