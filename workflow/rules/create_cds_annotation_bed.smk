localrules: create_cds_annotation_bed

rule create_cds_annotation_bed:
    input:
        annotation_bed='results/{}.bed'.format(basename(config['ref_gff3']).split('.gff')[0]),
        isotable='results/ref_cds_isoforms.tsv'
    output:    
        'results/cdsonly_{}.bed'.format(basename(config['ref_gff3']).split('.gff')[0])
    threads: 1    
    shell:
        """
        python workflow/scripts/FilterReferenceAnnotationBedForCDS.py \
        {input.isotable} {input.annotation_bed}
        """ 
    
