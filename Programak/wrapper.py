import multiprocessing
import sys
from time import sleep

import weka.core.jvm as jwm
from weka.core.converters import Loader
from weka.classifiers import Classifier, Evaluation
from weka.filters import Filter
from weka.core.classes import Random, from_commandline
from weka.core.dataset import Instances, Instance, Attribute

EMAITZA_FITX = "wrapper_emaitzak.txt"
SMO_CMD = 'weka.classifiers.functions.SMO -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.PolyKernel -E 1.0 -C 250007" -calibrator "weka.classifiers.functions.Logistic -R 1.0E-8 -M -1 -num-decimal-places 4"'
LMT_CMD = 'weka.classifiers.trees.LMT -I -1 -M 15 -W 0.0'
CROSS_VALIDATION = 10

#fitxategia = "..\irteera\ImageFilter_convert-equalize_PHOGF.arff"
fitxategia = "..\irteera\ImageFilter_convert-unsharp5x5_EHF.arff"

def subset_kargatu():
    # Lerroa: atributua, portzentaia
    lerroak = []
    with open(EMAITZA_FITX, "r") as f:
        while l := f.readline():
            lerroak.append(l)

    return [l.split(";")[0] for l in lerroak]


def gorde_atributu_berria(emaitza):
    with open(EMAITZA_FITX, "a") as f:
        f.write("\n"+f"{emaitza[0]};{emaitza[1]}")


def lanak_sortu(kant, atributuak):
    i = 0
    lanak = [[] for _ in range(0,kant)]
    for a in atributuak:
        lanak[i % kant].append(a)
        i += 1
    return lanak

def atributuak_lortu_process(id, atributuak, emaitza, balioak):
    global fitxategia
    jwm.start(max_heap_size="512m")
    loader = Loader(classname="weka.core.converters.ArffLoader")
    dataset = loader.load_file(fitxategia)
    dataset.class_is_last()
    max : dict[str, float] = {"atributua": "", "portzentaia": 0.0}
    for a in atributuak:
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

    balioak.append((id, max["atributua"], max["portzentaia"]))
    jwm.stop()
    
            

def atributuak_lortu(zerrenda: list, oinarria=[]):
    emaitza = oinarria
    print(emaitza)
    while len(emaitza) < len(zerrenda):
        print(emaitza)

        atributuak = [a for a in zerrenda if (not a in emaitza) and (a != 'class')]
        mn = multiprocessing.Manager()
        balioak = mn.list()
        cpus = multiprocessing.cpu_count() - 5
        lanak = lanak_sortu(cpus, atributuak)
        prozesuak = []

        for i in range(0, cpus):
            p = multiprocessing.Process(target=atributuak_lortu_process, name="P_"+str(i), args=("P_"+str(i), lanak[i], emaitza, balioak))
            prozesuak.append(p)
            p.start()
            sleep(0.1)

        for p in prozesuak:
            p.join()
        
        print(balioak)

        max = ("", 0.0)
        for _, a, p in balioak:
            if p > max[1]:
                max = (a, p)
        
        emaitza.append(max[0])
        gorde_atributu_berria(max)
        print(f"Berria: {max[0]} eta {max[1]}")


def portzentaia_zuzen(subset: Instances):
    sailkatzailea = from_commandline(LMT_CMD, classname="weka.classifiers.Classifier")
    eval = Evaluation(subset)
    eval.crossvalidate_model(sailkatzailea, subset, CROSS_VALIDATION, Random(1))
    return eval.percent_correct


def main():
    global fitxategia
    jwm.start(max_heap_size="512m")
    loader = Loader(classname="weka.core.converters.ArffLoader")
    dataset = loader.load_file(fitxategia)
    dataset.class_is_last()
    atr_zer = list(dataset.attribute_names())
    fitx_subset = subset_kargatu()
    atributuak_lortu(atr_zer, oinarria=fitx_subset)


if __name__ == "__main__":
    main()