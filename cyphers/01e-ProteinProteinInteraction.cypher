LOAD CSV WITH HEADERS FROM "FILE:///01e-ProteinProteinInteractionProtein.csv" AS row
MERGE (p:Protein{id: row.id})
SET p.name = row.name, p.accession = row.accession, p.proId = row.proId, 
    p.sequence = row.sequence, p.start = toInteger(row.start), p.end = toInteger(row.end), p.fullLength = row.fullLength, 
    p.taxonomyId = row.taxonomyId
RETURN count(p) as Protein
;
LOAD CSV WITH HEADERS FROM "FILE:///01e-ProteinProteinInteractionProtein.csv" AS row
MERGE (p:ProteinName{id: coalesce(row.proteinName, '') +  coalesce(row.accession, '') + coalesce(row.proId, '')})
SET p.name = row.name, p.accession = row.accession, p.proId = row.proId
RETURN count(p) as ProteinName
;
LOAD CSV WITH HEADERS FROM "FILE:///01e-ProteinProteinInteractionProtein.csv" AS row
MATCH (p1:Protein)
MATCH (p2:Protein{id: row.id})
WHERE p1.accession = row.accession AND p1.fullLength = 'True' AND p2.fullLength = 'False'
MERGE (p1)-[c:CLEAVED_TO]->(p2)
RETURN count(c) as CLEAVED_TO
;
LOAD CSV WITH HEADERS FROM "FILE:///01e-ProteinProteinInteractionProtein.csv" AS row
MATCH (p:Protein{id: row.id})
MATCH (pn:ProteinName{id: coalesce(row.proteinName, '') +  coalesce(row.accession, '') + coalesce(row.proId, '')})
MERGE (p)-[n:NAMED_AS]->(pn)
RETURN count(n) as NAMED_AS
;                     
LOAD CSV WITH HEADERS FROM "FILE:///01e-ProteinProteinInteraction.csv" AS row
MATCH (pa:Protein{id: row.id_a})
MATCH (pb:Protein{id: row.id_b})
MERGE (pa)-[i:INTERACTS_WITH]->(pb)
RETURN count(i) as INTERACTS_WITH
;


