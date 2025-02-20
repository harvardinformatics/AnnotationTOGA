localrules: orthology_filter_annotation_bed

rule orthology_filter_annotation_bed:
    input: 
        annotation='results/toga_annotation/query_annotation.bed',
        ortho_table='results/toga_annotation/orthology_classification.tsv'
    output:
        'results/toga_annotation/filtered_query_annotation.bed'
    threads: 1
    shell:
        'python workflow/scripts/FilterTogaAnnotationBedFile.py -bedin {input.annotation} -orthtable {input.ortho_table}'
              
