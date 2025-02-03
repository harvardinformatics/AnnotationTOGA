localrules: create_cds_isoforms_table

rule create_cds_isoforms_table:
    input: 
        config['ref_gff3']
    output:
        'results/ref_cds_isoforms.tsv'
    threads: 1
    shell:
        """
        awk -F"\t" '$3=="mRNA"{{print $9}}' {input} | \
        awk -F";" '{{print $3"\t"$1}}' | \
        sed 's/gene_name=//g' | \
        sed 's/ID=//g' > {output}
        """ 
