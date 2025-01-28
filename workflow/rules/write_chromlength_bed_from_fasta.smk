rule write_chromlength_bed:
    input:
        config["genomefasta"]
    output:    
        "chromosome_lengths.write_chromlength_bed
    conda:
        "../envs/biopython.yaml"
    script:
        "../scripts/WriteChromLengthBedFromFasta.py
    