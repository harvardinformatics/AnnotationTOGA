import argparse
from collections import OrderedDict

fields = ['seqid', 'source', 'type', 'start',
          'end', 'score', 'strand', 'phase', 'attributes']


def ParseMrnaAttributes(linedict):
    attribute_list = linedict['attributes'].split(';')
    attribute_dict = {}
    for attribute in attribute_list:
        key,value = attribute.split('=')
        attribute_dict[key] = value
    return attribute_dict

def UpdateGeneIntervalDict(gene_interval_dict,orthology_dict,linedict):
    attribute_dict = ParseMrnaAttributes(linedict)
    start = int(linedict['start'])
    end = int(linedict['end'])
    geneid =  orthology_dict[attribute_dict['ID']]['query_gene']
    if geneid in gene_interval_dict:
        gene_interval_dict[geneid]['start'] = min(gene_interval_dict[geneid]['start'],start)
        gene_interval_dict[geneid]['end'] = max(gene_interval_dict[geneid]['end'],end) 
    else:
        gene_interval_dict[geneid] = {'start': start, 'end': end}
    
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
    parser.add_argument('-ortho-table','--toga-orthology-table',dest='orthology',type=str,help='TOGA orthology classification table')
    opts = parser.parse_args()

    ## build dictionary linking query (genome transferring annotation to) transcript id to query (region) gene id, and ref genome ts and gene info
    orthology_dict = ParseTogaOrthologClassification(opts.orthology)

    gff_out = open('geneIDupdate_%s' % opts.gff3,'w')
    gene_interval_dict = {}

    genes = set()
    
    with open(opts.gff3,'r') as firstpass:
        for line in firstpass:
            if line[0] != '#':
                linedict = dict(zip(fields,line.strip().split('\t')))
                if linedict['type'] in ['mRNA', 'transcript']:
                    gene_interval_dict = UpdateGeneIntervalDict(gene_interval_dict,orthology_dict,linedict)   

    with open(opts.gff3,'r') as gff_in:
        for line in gff_in:
            if line[0] == '#':
                gff_out.write(line)
            else:
                linedict = dict(zip(fields,line.strip().split('\t')))
                if linedict['type'] in ['mRNA', 'transcript']:
                    attribute_dict = ParseMrnaAttributes(linedict)
                    attribute_dict['geneID'] = orthology_dict[attribute_dict['ID']]['query_gene']                    
              
                    if attribute_dict['geneID'] not in genes:
                        gff_out.write('%s\t%s\tgene\t%s\t%s\t%s\t%s\t%s\tID=%s\n' % (linedict['seqid'],linedict['source'],
                                                                                  gene_interval_dict[attribute_dict['geneID']]['start'],
                                                                                  gene_interval_dict[attribute_dict['geneID']]['end'],
                                                                                  linedict['score'],linedict['strand'],linedict['phase'],attribute_dict['geneID']))
                        genes.add(attribute_dict['geneID'])

                    attribute_string = 'ID=%s;Parent=%s' % (attribute_dict['ID'],attribute_dict['geneID'])
                    new_line_list = []
                    for field in fields[:-1]:
                        new_line_list.append(linedict[field])
                    new_line_list.append(attribute_string)
                    gff_out.write('%s\n' % '\t'.join(new_line_list))
                else:
                    gff_out.write(line)
    


    gff_out.close()

