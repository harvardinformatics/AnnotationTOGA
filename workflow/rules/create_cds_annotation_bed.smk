localrules: create_cds_annotation_bed

rule create_cds_annotation_bed:
    input:
        annotation_bed='results/{}.bed'.format(basename(config['ref_gff3']).split('.gff')[0]),
    output:    
        'results/cdsonly_{}.bed'.format(basename(config['ref_gff3']).split('.gff')[0])
    params:
        cds_isoforms=config['cds_isoforms']
    threads: 1    
    shell:
        """
        python workflow/scripts/FilterReferenceAnnotationBedForCDS.py \
        {params.cds_isoforms} {input.annotation_bed}
        """ 
    
