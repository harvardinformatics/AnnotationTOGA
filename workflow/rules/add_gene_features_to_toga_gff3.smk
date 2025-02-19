localrules: add_gene_features_to_toga_gff3

rule add_gene_features_to_toga_gff3:
    input:
        annotation='results/toga_annotation/filtered_query_annotation.gff3',
        ortho_table='results/toga_annotation/orthology_classification.tsv' 
    output:
        'results/toga_annotation/geneIDupdate_filtered_query_annotation.gff3'
    threads: 1
    shell:
        'python workflow/scripts/AddGeneFeatureToTogaGff3.py -gff3 {input.annotation} -ortho-table {input.ortho_table}'
              
