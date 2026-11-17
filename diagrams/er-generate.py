# Generates the three ER diagrams (er-core, er-media-drafts, er-history-files) from the EF Core model snapshot.
# Usage: python3 er-generate.py <ArtAdmin.Persistence/Migrations/DataContextModelSnapshot.cs> <output dir> "<plantuml header lines>"
# Header used: "left to right direction\nskinparam nodesep 8\nskinparam ranksep 22" (as real newlines).
import re,sys
s=open(sys.argv[1]).read(); outdir=sys.argv[2]
blocks=re.split(r'\n            modelBuilder\.Entity\("', s)[1:]
tables={};cols={};rels=[]
for b in blocks:
    short=b.split('"',1)[0].split('.')[-1]
    t=re.search(r'b\.ToTable\("([^"]+)"',b)
    if t: tables[short]=t.group(1)
    ps=re.findall(r'b\.Property<([^>]+(?:<[^>]+>)?)>\("([^"]+)"\)',b)
    if ps: cols.setdefault(short,ps)
    for m in re.finditer(r'b\.HasOne\("([^"]+)", (?:"([^"]+)"|null)\)\s*\.With(Many|One)\((?:"([^"]+)")?\)\s*\.HasForeignKey\(([^)]*)\)',b):
        rels.append((short,m.group(1).split('.')[-1],m.group(3),m.group(5).replace('"','').split(',')[-1].strip()))
common={'Id','CreatedAt','UpdatedAt','Status','InstitutionId'}
tmap={'Guid':'uuid','Guid?':'uuid','string':'text','int':'int','int?':'int','bool':'bool','decimal':'numeric','DateTime':'timestamptz','DateTime?':'timestamptz','DateTimeOffset':'timestamptz','DateOnly?':'date','TimeSpan':'interval','JsonDocument':'jsonb','Vector':'vector'}
A=['Institution','InstitutionMembership','Agent','AgentEntity','Attribution','Location','Room','Entity','EntityGroup','EntityType','RecordSource','InventoryNumber','InventoryNumberCounter','Material','EntityMaterial','EntityTag','EntityEntityTag']
B=['Resource','ResourceEmbedding','ResourceEmbeddingFailure','SubPart','Measurement','Coordinate','EntityPosition','Draft','DraftResource','DraftMeasurement','DraftCoordinate']
C=['Event','EventType','EventCoordinate','Association','FileAttachment','RoomFileAttachments','EntityGroupFileAttachments']
assert set(A+B+C)==set(tables), set(tables)-set(A+B+C)
NORANK={('RecordSource','Entity'),('Location','Room'),('Coordinate','Measurement'),('EntityGroup','EntityGroup')}
def emit(name,group,header,extra=''):
    o=[f'@startuml {name}','!include _style.puml',header,'hide methods','']
    stubs=set()
    edges=[]
    for c,p,kind,fkc in rels:
        if p=='Institution' and c!='InstitutionMembership': continue
        if c not in group: continue
        if p not in group: stubs.add(p)
        nullable=any(n==fkc and ty.endswith('?') for ty,n in cols[c])
        nr='-[norank]-' if (p,c) in NORANK else '--'
        edges.append(f"{p} {'|o' if nullable else '||'}{nr}{'o|' if kind=='One' else 'o{'} {c}")
    for k in group:
        fk={r[3] for r in rels if r[0]==k}
        o.append(f'entity "{tables[k]}" as {k} {{')
        for ty,n in cols[k]:
            if n in common: continue
            typ=tmap.get(ty,ty)
            if n=='Files': typ='jsonb'
            o.append(f"  {n} <<FK>>" if n in fk else f"  {n} : {typ}")
        o.append('}')
    for k in sorted(stubs): o.append(f'entity "{tables[k]}" as {k} $stub')
    o+=['']+edges+[extra,'@enduml']
    open(f'{outdir}/{name}.puml','w').write('\n'.join(o)+'\n')
H=sys.argv[3]
emit('er-core',A,H.replace('nodesep 8','nodesep 13').replace('ranksep 22','ranksep 30'))
emit('er-media-drafts',B,H)
emit('er-history-files',C,H)
