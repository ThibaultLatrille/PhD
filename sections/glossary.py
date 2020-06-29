#!python3
import argparse
import inflect

p = inflect.engine()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-g', '--glossary', required=False, default="glossary.tex", type=str, dest="glossary")
    parser.add_argument('-i', '--input', required=False,
                        default=["intro.tex", "intro_inference.tex", "intro_selection.tex", "mut-bias.tex",
                                 "discussion.tex", "conclusion.tex"], type=str, nargs='+',
                        dest="input")
    args = parser.parse_args()

    glossary, acronym = {}, {}
    with open(args.glossary, 'r') as glos_file:
        for line in glos_file:
            if "newacronym" in line:
                key, accro, _ = line.split("}{")
                if len(accro) < 2: continue
                acronym[accro] = key.replace("\\newacronym{", "")
            elif "newglossaryentry" in line:
                key, desc = line.split("}{")
                glos, _ = desc.split("},description={")
                glossary[glos.replace("name={", "")] = key.replace("\\newglossaryentry{", "")

    print(glossary)
    print(acronym)
    context_list = [" {0} ", " {0}.", " {0},", " {0}:", " {0};", "({0})"]
    for file in args.input:
        lines = []
        for line in open(file, 'r').readlines():
            f = line
            for context in context_list:
                for k, v in glossary.items():
                    f = f.replace(context.format(k), context.format("\\gls{" + v + "}"))
                    plural = p.plural(v)
                    f = f.replace(context.format(k), context.format("\\glspl{" + plural + "}"))
                    if v[0].capitalize() == v[0]: continue
                    f = f.replace(context.format(k), context.format("\\Gls{" + v.capitalize() + "}"))
                    f = f.replace(context.format(k), context.format("\\Glspl{" + plural.capitalize() + "}"))
                for k, v in acronym.items():
                    f = f.replace(context.format(k), context.format("\\acrshort{" + v + "}"))
            if f != line: print(f)
            lines.append(f)
        open(file, 'w').writelines(lines)
