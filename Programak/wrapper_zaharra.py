import sys

import weka.core.jvm as jwm
from weka.core.converters import Loader
from weka.classifiers import Classifier, Evaluation
from weka.filters import Filter
from weka.core.classes import Random, from_commandline
from weka.core.dataset import Instances, Instance, Attribute

EMAITZA_FITX = "emaitzak.txt"
SMO_CMD = 'weka.classifiers.functions.SMO -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.PolyKernel -E 1.0 -C 250007" -calibrator "weka.classifiers.functions.Logistic -R 1.0E-8 -M -1 -num-decimal-places 4"'
CROSS_VALIDATION = 10

def subset_kargatu():
    # Lerroa: atributua, portzentaia
    lerroak = []
    with open(EMAITZA_FITX, "r") as f:
        while l := f.readline():
            lerroak.append(l)

    return [l.split(",")[0] for l in lerroak]


def gorde_atributu_berria(emaitza: dict[str, float]):
    with open(EMAITZA_FITX, "a") as f:
        f.write(f"{emaitza['atributua']}, {emaitza['portzentaia']}\r\n")
    

def atributuak_lortu(zerrenda: list, dataset: Instances, oinarria=[]):
    emaitza = oinarria
    while len(emaitza) < len(zerrenda):
        max : dict[str, float] = {"atributua": "", "portzentaia": 0.0}
        for a in zerrenda:
            if not a in emaitza:
                tmp = emaitza.copy()
                tmp.append(a)
                tmp.append('class')
                subset = dataset.subset(col_names=tmp)
                subset.class_is_last()
                em = portzentaia_zuzen(subset)
                if em > max["portzentaia"]:
                    max["atributua"] = a
                    max["portzentaia"] = em
                print(f"Tmp: {a}, {em}")
        
        emaitza.append(max["atributua"])
        gorde_atributu_berria(max)
        print(f"Berria: {max['atributua']} eta {max['portzentaia']}")


def portzentaia_zuzen(subset: Instances):
    sailkatzailea = from_commandline(SMO_CMD, classname="weka.classifiers.Classifier")
    eval = Evaluation(subset)
    eval.crossvalidate_model(sailkatzailea, subset, CROSS_VALIDATION, Random(1))
    return eval.percent_correct


def main():
    if len(sys.argv) >= 2:
        jwm.start()
        loader = Loader(classname="weka.core.converters.ArffLoader")
        dataset = loader.load_file(sys.argv[1])
        dataset.class_is_last()
        atr_zer = list(dataset.attribute_names())
        fitx_subset = subset_kargatu()
        atributuak_lortu(atr_zer, dataset, oinarria=fitx_subset)
        
    else:
        print("Error")


if __name__ == "__main__":
    main()