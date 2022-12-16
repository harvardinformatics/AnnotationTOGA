import argparse

fields = ['seqid', 'source', 'type', 'start',
          'end', 'score', 'strand', 'phase', 'attributes']


def ParseMrnaAttributes(linedict):
    attribute_list = linedict['attributes'].split(';')
    attribute_dict = {}
    for attribute in attribute_list:
        key,value = attribute.split('=')
        attribute_dict[key] = value
    return attribute_dict

def UpdateGeneIntervalDict(gene_interval_dict,linedict):
    attribute_dict = ParseMrnaAttributes(linedict)
    start = int(linedict['start'])
    end = int(linedict['end'])
    if 'geneID' in attribute_dict:
        if attribute_dict['geneID'] in gene_interval_dict:
            gene_interval_dict[attribute_dict['geneID']]['start'] = min(gene_interval_dict[attribute_dict['geneID']]['start'],start)
            gene_interval_dict[attribute_dict['geneID']]['end'] = max(gene_interval_dict[attribute_dict['geneID']]['end'],end) 
        else:
            gene_interval_dict[attribute_dict['geneID']] = {'start': start, 'end': end}
    
    return gene_interval_dict   
         
    
def ParseTogaOrthologClassification(tablefile):
    fopen = open(tablefile,'r')
    toga_dict = {}
    fopen.readline()
    for line in fopen:
        target_gene,target_transcript,query_gene,query_transcript,orthology = line.strip().split()
        toga_dict[query_transcript] = {'query_gene': query_gene, 'orthology': orthology,
                                        'target_gene': target_gene, 'target_transcript': target_transcript}
    return toga_dict
        
    


if __name__=="__main__": 
    parser = argparse.ArgumentParser(description="script to add a new gene-level features for gff3 without gene features; requires gene id in mRNA attribute")
    parser.add_argument('-gff3','--gff3-file',dest='gff3',type=str,help='gff3 file missing gene features')
    parser.add_argument('-ortho-table','--toga-orthology-table',dest='orthology',type=str,help='TOGA orthology classification table'}
    opts = parser.parse_args()

    ## build dictionary linking query (genome transferring annotation to) transcript id to query (region) gene id, and ref genome ts and gene info
    toga_dict = ParseTogaOrthologClassification(opts.orthology)

    gff_out = open('wgenefeatures_%s' % opts.gff3,'w')
    gene_interval_dict = {}

    ## HERE need to add gene label step using orthology table, save file, then reopen add add gene intervals, 
    with open(opts.gff3, 'r') as firstpass:
        for line in firstpass:
            if line[0] != '#':
                linedict = dict(zip(fields,line.strip().split('\t')))
                if linedict['type'] == 'mRNA':
                    gene_interval_dict = UpdateGeneIntervalDict(gene_interval_dict,linedict) 
        firstpass.close()

    with open(opts.gff3,'r') as secondpass:
        for line in secondpass:
            if line[0] == '#':
                gff_out.write(line)
            else:
                linedict = dict(zip(fields,line.strip().split('\t')))
                if linedict['type'] == 'mRNA':
                    attribute_dict = ParseMrnaAttributes(linedict)
                    if 'geneID' in attribute_dict:
                        if attribute_dict['geneID'] in gene_interval_dict:
                            gff_out.write('%s\t%s\tgene\t%s\t%s\t.\t%s\t.\tID=%s\n' % (linedict['seqid'],
                            linedict['source'],gene_interval_dict[attribute_dict['geneID']]['start'],
                            gene_interval_dict[attribute_dict['geneID']]['end'],linedict['strand'],attribute_dict['geneID']))
                            gene_interval_dict.pop(attribute_dict['geneID'])
                            gff_out.write(line.replace('geneID','Parent'))
                        else:
                            gff_out.write(line.replace('geneID','Parent'))
                    else:
                        raise ValueError('geneID attribute label not found in mRNA attribute')
                else:
                    gff_out.write(line)
    gff_out.close()

