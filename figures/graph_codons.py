import graph_tool.all as gt
from itertools import product
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.cm import ScalarMappable
from matplotlib.colors import Normalize


def distance_str(str_1, str_2):
    assert len(str_1) == len(str_2)
    return len([0 for i, j in zip(str_1, str_2) if i != j])


nucleotides = ["A", "C", "G", "T"]
codontable = {
    'ATA': 'I', 'ATC': 'I', 'ATT': 'I', 'ATG': 'M',
    'ACA': 'T', 'ACC': 'T', 'ACG': 'T', 'ACT': 'T',
    'AAC': 'N', 'AAT': 'N', 'AAA': 'K', 'AAG': 'K',
    'AGC': 'S', 'AGT': 'S', 'AGA': 'R', 'AGG': 'R',
    'CTA': 'L', 'CTC': 'L', 'CTG': 'L', 'CTT': 'L',
    'CCA': 'P', 'CCC': 'P', 'CCG': 'P', 'CCT': 'P',
    'CAC': 'H', 'CAT': 'H', 'CAA': 'Q', 'CAG': 'Q',
    'CGA': 'R', 'CGC': 'R', 'CGG': 'R', 'CGT': 'R',
    'GTA': 'V', 'GTC': 'V', 'GTG': 'V', 'GTT': 'V',
    'GCA': 'A', 'GCC': 'A', 'GCG': 'A', 'GCT': 'A',
    'GAC': 'D', 'GAT': 'D', 'GAA': 'E', 'GAG': 'E',
    'GGA': 'G', 'GGC': 'G', 'GGG': 'G', 'GGT': 'G',
    'TCA': 'S', 'TCC': 'S', 'TCG': 'S', 'TCT': 'S',
    'TTC': 'F', 'TTT': 'F', 'TTA': 'L', 'TTG': 'L',
    'TAC': 'Y', 'TAT': 'Y', 'TAA': 'X', 'TAG': 'X',
    'TGC': 'C', 'TGT': 'C', 'TGA': 'X', 'TGG': 'W'}
aa_order = []
for k, v in sorted(codontable.items(), key=lambda kv: kv[0]):
    if v != "X" and v not in aa_order:
        aa_order.append(v)


def codon_circos(cmap='tab20', filetype="pdf", reverse=False):
    cm = plt.cm.get_cmap(cmap)
    cmappable = ScalarMappable(norm=Normalize(vmin=0, vmax=20), cmap=cm)

    g_codons = gt.Graph(directed=False)
    g_codons.vp.codon = g_codons.new_vertex_property("string")
    g_codons.vp.aa = g_codons.new_vertex_property("string")
    g_codons.vp.aa_index = g_codons.new_vertex_property("int")
    g_codons.vp.aa_color = g_codons.new_vertex_property("vector<float>")
    g_codons.vp.codon_index = g_codons.new_vertex_property("int")
    g_codons.ep.syn = g_codons.new_edge_property("bool")
    g_codons.ep.grad = g_codons.new_edge_property("vector<float>")

    for aa_index, aa in enumerate(aa_order):
        if aa == "X": continue
        for codon_index, c in enumerate(sorted([k for k, v in codontable.items() if v == aa])):
            v = g_codons.add_vertex()
            g_codons.vp.codon[v] = c
            g_codons.vp.aa[v] = aa
            g_codons.vp.codon_index[v] = codon_index
            g_codons.vp.aa_index[v] = aa_index
            g_codons.vp.aa_color[v] = cmappable.to_rgba(aa_index)

    for ref in g_codons.vertices():
        for alt in g_codons.vertices():
            if alt <= ref: continue
            codon_ref, codon_alt = g_codons.vp.codon[ref], g_codons.vp.codon[alt]
            if distance_str(codon_ref, codon_alt) != 1: continue
            if codontable[codon_ref] != codontable[codon_alt]:
                e_c = g_codons.add_edge(ref, alt)
                g_codons.ep.syn[e_c] = False
                x = cmappable.to_rgba(g_codons.vp.aa_index[ref])[:3]
                y = cmappable.to_rgba(g_codons.vp.aa_index[alt])[:3]
                if reverse: x, y = y, x
                g_codons.ep.grad[e_c] = [0.0, *x, 0.75, 1.0, *y, 0.75]

    for ref in g_codons.vertices():
        for alt in g_codons.vertices():
            if alt >= ref: continue
            codon_ref, codon_alt = g_codons.vp.codon[ref], g_codons.vp.codon[alt]
            if distance_str(codon_ref, codon_alt) != 1: continue
            if codontable[codon_ref] == codontable[codon_alt]:
                e_c = g_codons.add_edge(ref, alt)
                g_codons.ep.syn[e_c] = True
                syn_color = 0.0, 0.0, 0.0, 1.0
                g_codons.ep.grad[e_c] = [0.0, *syn_color, 1.0, *syn_color]

    assert g_codons.num_vertices() == 61
    dist = gt.shortest_distance(g_codons)
    r = max([max(dist[g_codons.vertex(i)].a) for i in g_codons.vertices()])
    print('Codons graph radius : {0}'.format(r))
    print('Codons : {0} transitions out of {1} possibles.'.format(g_codons.num_edges(), 61 * 60 / 2))
    syn_array = g_codons.ep.syn.get_array()
    print('Codons : {0} are synonymous and {1} are non-synonymous.'.format(sum(syn_array),
                                                                           len(syn_array) - sum(syn_array)))
    state = gt.NestedBlockState(g_codons, bs=[g_codons.vp.aa_index, g_codons.vp.codon_index], sampling=False)
    t = gt.get_hierarchy_tree(state)[0]
    tpos = gt.radial_tree_layout(t, t.vertex(t.num_vertices() - 1), weighted=True)
    cts = gt.get_hierarchy_control_points(g_codons, t, tpos)
    pos = g_codons.own_property(tpos)
    gt.graph_draw(g_codons, pos=pos, edge_control_points=cts, edge_gradient=g_codons.ep.grad, edge_pen_width=2.5,
                  vertex_text=g_codons.vp.codon, vertex_anchor=0, vertex_font_size=9, vertex_pen_width=1.6,
                  vertex_color=(0.65, 0.65, 0.65, 1), vertex_fill_color=g_codons.vp.aa_color, vertex_size=25.0,
                  output="gt-codon-{0}.{1}".format(cmap, filetype))


def amino_acid_circos(cmap='tab20', filetype="pdf", reverse=False):
    cm = plt.cm.get_cmap(cmap)
    cmappable = ScalarMappable(norm=Normalize(vmin=0, vmax=20), cmap=cm)

    g_aa = gt.Graph(directed=False)
    g_aa.vp.aa = g_aa.new_vertex_property("string")
    g_aa.vp.aa_color = g_aa.new_vertex_property("vector<float>")
    g_aa.vp.count = g_aa.new_vertex_property("float")
    g_aa.ep.count = g_aa.new_edge_property("float")
    g_aa.ep.grad = g_aa.new_edge_property("vector<float>")

    for aa_index, aa in enumerate(aa_order):
        if aa == "X": continue
        v = g_aa.add_vertex()
        g_aa.vp.aa[v] = aa
        g_aa.vp.aa_color[v] = cmappable.to_rgba(aa_index)
        g_aa.vp.count[v] = np.sqrt(len([k for k, v in codontable.items() if v == aa])) * 28

    adj = np.zeros((g_aa.num_vertices(), g_aa.num_vertices()))
    for ref_index, ref in enumerate(g_aa.vertices()):
        for alt_index, alt in enumerate(g_aa.vertices()):
            if alt <= ref: continue
            aa_ref, aa_alt = g_aa.vp.aa[ref], g_aa.vp.aa[alt]
            c_ref = [k for k, v in codontable.items() if v == aa_ref]
            c_alt = [k for k, v in codontable.items() if v == aa_alt]
            nei = [(r, a) for r, a in product(c_ref, c_alt) if distance_str(r, a) == 1]
            if len(nei) > 0:
                e_aa = g_aa.add_edge(ref, alt)
                x = cmappable.to_rgba(ref_index)[:3]
                y = cmappable.to_rgba(alt_index)[:3]
                if reverse: x, y = y, x
                g_aa.ep.grad[e_aa] = [0.0, *x, 0.75, 1.0, *y, 0.75]
                g_aa.ep.count[e_aa] = len(nei) * 2.0
                adj[ref_index, alt_index] = len(nei)

    table = open("aa-adjacency.tex", "w")
    table.writelines("\\begin{table}[H]\n\\centering\n")
    table.writelines("\\begin{tabular}{|c||" + "c|" * g_aa.num_vertices() + "}\n")
    table.writelines("\\hline & ")
    table.writelines(" & ".join(map(lambda x: "\\textbf{" + x + "}", g_aa.vp.aa)) + "\\\\\n")
    table.writelines("\\hline\n\\hline ")
    for i in range(adj.shape[0]):
        elts = ["\\textbf{" + g_aa.vp.aa[i] + "}"]
        for j in range(adj.shape[1]):
            if i < j:
                elts.append("{:d}".format(int(adj[i][j])))
            else:
                elts.append("-")
        table.writelines(" & ".join(elts) + "\\\\\n\\hline ")
    table.writelines("\\end{tabular}\n")
    table.writelines("\\caption[]{}\n")
    table.writelines("\\end{table}\n")
    table.close()

    assert g_aa.num_vertices() == 20
    dist = gt.shortest_distance(g_aa)
    r = max([max(dist[g_aa.vertex(i)].a) for i in g_aa.vertices()])
    print('Amino-acids graph radius : {0}'.format(r))
    dict_distance = {1: [], 2: [], 3: []}
    for source in g_aa.vertices():
        for target in g_aa.vertices():
            if source <= target: continue
            dict_distance[int(gt.shortest_distance(g_aa, source, target))].append(
                "{0}-{1}".format(g_aa.vp.aa[source], g_aa.vp.aa[target]))

    for k, v in dict_distance.items():
        print("d={0}: {1} pairs".format(k, len(v)))
        print(", ".join(v))

    print('Amino-acids : {0} transitions out of {1} possibles '.format(g_aa.num_edges(), 20 * 19 / 2))
    state = gt.minimize_nested_blockmodel_dl(g_aa, deg_corr=True)
    t = gt.get_hierarchy_tree(state)[0]
    tpos = gt.radial_tree_layout(t, t.vertex(t.num_vertices() - 1), weighted=True)
    cts = gt.get_hierarchy_control_points(g_aa, t, tpos)
    pos = g_aa.own_property(tpos)
    gt.graph_draw(g_aa, pos=pos, edge_control_points=cts, vertex_anchor=0, vertex_text=g_aa.vp.aa,
                  vertex_fill_color=g_aa.vp.aa_color, vertex_size=g_aa.vp.count, vertex_font_size=16,
                  vertex_pen_width=3.2, vertex_color=(0.65, 0.65, 0.65, 1),
                  edge_gradient=g_aa.ep.grad, edge_pen_width=g_aa.ep.count,
                  output="gt-aa-{0}.{1}".format(cmap, filetype))


for cmap in ['tab20b']:  # ['tab20', 'tab20b', 'tab20c']
    amino_acid_circos(cmap=cmap, filetype="pdf", reverse=False)
    codon_circos(cmap=cmap, filetype="pdf", reverse=False)
