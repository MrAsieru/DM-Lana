import itertools
import multiprocessing
import os
import platform
import re
from datetime import datetime as dt
from datetime import timedelta
import tempfile, shutil

IRTEERA_DIREKTORIOA=os.path.join('..','irteera')
OUTPUT_DIREKTORIOA=os.path.join('output','multisailkatzaileak')
if platform.system() == 'Windows':
    NULL = "$null"
else:
    NULL = "/dev/null"

hasiera_data=dt.now()
orain=0
guztira=0


SAILKATZAILEAK=[
    # Bayes
    #('BayesNet',                        'weka.classifiers.bayes.BayesNet -- -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 3 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5'),    
    ('NaiveBayes',                      'weka.classifiers.bayes.NaiveBayes'),   
    ('NaiveBayesMultinomial',           'weka.classifiers.bayes.NaiveBayesMultinomial'),    
    ('NaiveBayesMultinomialUpdateable', 'weka.classifiers.bayes.NaiveBayesMultinomialUpdateable'),    
    ('NaiveBayesUpdateable',            'weka.classifiers.bayes.NaiveBayesUpdateable'),
    # Functions
    ('SMO',                             'weka.classifiers.functions.SMO -- -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.PolyKernel -E 1.0 -C 250007" -calibrator "weka.classifiers.functions.Logistic -R 1.0E-8 -M -1 -num-decimal-places 4"'),
    # Lazy
    # 5
    ('1-NN',                            'weka.classifiers.lazy.IBk -- -K 1 -W 0 -I -A "weka.core.neighboursearch.LinearNNSearch -A \\"weka.core.EuclideanDistance -R first-last\\""'),   
    ('3-NN',                            'weka.classifiers.lazy.IBk -- -K 3 -W 0 -I -A "weka.core.neighboursearch.LinearNNSearch -A \\"weka.core.EuclideanDistance -R first-last\\""'),   
    ('7-NN',                            'weka.classifiers.lazy.IBk -- -K 7 -W 0 -I -A "weka.core.neighboursearch.LinearNNSearch -A \\"weka.core.EuclideanDistance -R first-last\\""'),   
    ('11-NN',                           'weka.classifiers.lazy.IBk -- -K 11 -W 0 -I -A "weka.core.neighboursearch.LinearNNSearch -A \\"weka.core.EuclideanDistance -R first-last\\""'),   
    #('KStar',                           'weka.classifiers.lazy.KStar -- -B 20 -M a'),    
    # Rules
    ('DecisionTable',                   'weka.classifiers.rules.DecisionTable -X 1 -S "weka.attributeSelection.BestFirst -D 1 -N 5"'),
    # 10
    ('JRip',                            'weka.classifiers.rules.JRip -F 3 -N 2.0 -O 2 -S 1'),
    ('OneR',                            'weka.classifiers.rules.OneR -B 6'),
    ('PART',                            'weka.classifiers.rules.PART -C 0.25 -M 2'),
    ('ZeroR',                           'weka.classifiers.rules.PART -C 0.25 -M 2'),
    # Tree
    ('HoeffdingTree',                   'weka.classifiers.trees.HoeffdingTree -- -L 2 -S 1 -E 1.0E-7 -H 0.05 -M 0.01 -G 200.0 -N 0.0'),    
    # 15
    ('J48',                             'weka.classifiers.trees.J48 -- -C 0.25 -M 2'),    
    #('LMT',                             'weka.classifiers.trees.LMT -- -I -1 -M 15 -W 0.0'),   
    ('RandomForest',                    'weka.classifiers.trees.RandomForest -- -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1'),  
    ('RandomTree',                      'weka.classifiers.trees.RandomTree -- -K 0 -M 1.0 -V 0.001 -S 1'),  
    ('REPTree',                         'weka.classifiers.trees.REPTree -- -M 2 -V 0.001 -N 3 -S 1 -L -1 -I 0.0')
]

def aukeratutako_convert_filtro(izena):
    return re.search(r"^ImageFilter_convert-(equalize|unsharp5x5)_(EHF|PHOGF).arff", izena)


def arff_informazioa(izena):
    # (Convert, Filter)
    r = re.search(r"^ImageFilter_([^_]*)_([^\._]*)(_.*)?.arff", izena)
    return (r.group(1), r.group(2))


def kalkulatuta_dago(irudi_mota, filtroa, multisailkatzailea, sailkatzailea):
    for f_izena in os.listdir(OUTPUT_DIREKTORIOA):
        r = re.search(r"^([^_]+)_([^_]+)_([^_]+)_(.*)$", f_izena)
        if r and irudi_mota == r.group(1) and filtroa == r.group(2) and multisailkatzailea == r.group(3) and sailkatzailea == r.group(4):
            file_stats = os.stat(os.path.join(OUTPUT_DIREKTORIOA, f_izena))
            return file_stats.st_size > 0
    return False


def data_formatua(s):
    td = timedelta(seconds=s)
    return str(td)


def eta_kalkulatu():
    global orain, guztira, hasiera_data
    orain += 1
    d = (dt.now() - hasiera_data).total_seconds()
    denbora_tot = data_formatua(d)
    geratzen_da = (guztira - orain)*((dt.now() - hasiera_data).total_seconds()/orain)
    denbora_eta = data_formatua(geratzen_da)
    return f"Eginda: {orain}/{guztira} ({denbora_tot}) ETA:({denbora_eta})"


def ez_egin(metasailkatzailea, sailkatzailea):
    return (sailkatzailea == "KStar" or sailkatzailea == "LMT" or sailkatzailea == "BayesNet") and (metasailkatzailea == "Bagging" or metasailkatzailea == "Boosting")


def Bagging(arff, sailkatzailea):
    irudi_mota, filtro_mota = arff_informazioa(os.path.basename(arff))
    sailkatzailea_izena, sailkatzailea_konf = sailkatzailea

    if not (kalkulatuta_dago(irudi_mota, filtro_mota, 'Bagging', sailkatzailea_izena) or ez_egin("Bagging", sailkatzailea_izena)):
        print(f"{irudi_mota}_{filtro_mota} - Bagging({sailkatzailea_izena}) exekutatzen")
        cmd = f'java -Xmx5120M -classpath weka.jar weka.classifiers.meta.Bagging -t "{arff}" -P 100 -S 1 -num-slots 1 -I 10 -W {sailkatzailea_konf} 1> "{os.path.join(OUTPUT_DIREKTORIOA, f"{irudi_mota}_{filtro_mota}_Bagging_{sailkatzailea_izena}")}" 2> {NULL}'
        os.system(cmd)
    else:
        print(f"{irudi_mota}_{filtro_mota} - Bagging({sailkatzailea_izena}) kalkulatuta dago")
    print(eta_kalkulatu())


def Boosting(arff, sailkatzailea):
    irudi_mota, filtro_mota = arff_informazioa(os.path.basename(arff))
    sailkatzailea_izena, sailkatzailea_konf = sailkatzailea

    if not (kalkulatuta_dago(irudi_mota, filtro_mota, 'Boosting', sailkatzailea_izena) or ez_egin("Boosting", sailkatzailea_izena)):
        print(f"{irudi_mota}_{filtro_mota} - Boosting({sailkatzailea_izena}) exekutatzen")
        cmd = f'java -Xmx5120M -classpath weka.jar weka.classifiers.meta.AdaBoostM1 -t "{arff}" -P 100 -S 1 -I 10 -W {sailkatzailea_konf} 1> "{os.path.join(OUTPUT_DIREKTORIOA, f"{irudi_mota}_{filtro_mota}_Bagging_{sailkatzailea_izena}")}" 2> {NULL}'
        os.system(cmd)
    else:
        print(f"{irudi_mota}_{filtro_mota} - Boosting({sailkatzailea_izena}) kalkulatuta dago")
    print(eta_kalkulatu())


def Voting(arff, sailkatzaileak, metodoa):
    irudi_mota, filtro_mota = arff_informazioa(os.path.basename(arff))

    sailkatzaile_konf = '" -B "'.join([j.replace('\\"', '\\\\"').replace('"', '\\"').replace(' --','') for (i,j) in sailkatzaileak])
    sailkatzaile_izenak = "_".join([i for (i,j) in sailkatzaileak])

    if not kalkulatuta_dago(irudi_mota, filtro_mota, f'Voting-{metodoa}', sailkatzaile_izenak):
        print(f"{irudi_mota}_{filtro_mota} - Voting({sailkatzaile_izenak}) exekutatzen")
        cmd = f'java -Xmx5120M -classpath weka.jar weka.classifiers.meta.Vote -t "{arff}" -S 1 -B "{sailkatzaile_konf}" -R {metodoa} 1> "{os.path.join(OUTPUT_DIREKTORIOA, f"{irudi_mota}_{filtro_mota}_Voting-{metodoa}_{sailkatzaile_izenak}")}"' #2> {NULL}
        os.system(cmd)
    else:
        print(f"{irudi_mota}_{filtro_mota} - Voting({sailkatzaile_izenak}) kalkulatuta dago")
    #print(eta_kalkulatu())


def Voting_process(lana, arff_fitxategiak):
    for f_izena in arff_fitxategiak:
        if os.path.isfile(f_izena):
            for l in lana:
                for m in ["PROD", "MAJ", "MIN", "MAX"]:
                    print(f_izena)
                    Voting(os.path.join(IRTEERA_DIREKTORIOA, f_izena), [SAILKATZAILEAK[i] for i in l], m)


def Stacking(arff, sailkatzaileak, meta):
    irudi_mota, filtro_mota = arff_informazioa(os.path.basename(arff))

    sailkatzaile_konfigurazioak = '" -B "'.join([j.replace('\\"', '\\\\"').replace('"', '\\"').replace(' --','') for (i,j) in sailkatzaileak])
    sailkatzaile_izenak = "_".join([i for (i,j) in sailkatzaileak])

    meta_izena, meta_konf = meta
    meta_konf = meta_konf.replace('\\"', '\\\\"').replace('"', '\\"').replace(' --','')

    if not kalkulatuta_dago(irudi_mota, filtro_mota, 'Stacking', sailkatzaile_izenak+'_'+meta_izena):
        print(f"{irudi_mota}_{filtro_mota} - Stacking({sailkatzaile_izenak+'_'+meta_izena}) exekutatzen")
        cmd = f'java -Xmx5120M -classpath weka.jar weka.classifiers.meta.Stacking -t "{arff}" -X 10 -M "{meta_konf}" -S 1 -num-slots 1 -B "{sailkatzaile_konfigurazioak}" 1> "{os.path.join(OUTPUT_DIREKTORIOA, f"{irudi_mota}_{filtro_mota}_Stacking_{sailkatzaile_izenak}_{meta_izena}")}"'
        print(cmd)
        os.system(cmd)
    else:
        print(f"{irudi_mota}_{filtro_mota} - Stacking({sailkatzaile_izenak+'_'+meta_izena}) kalkulatuta dago")
    print(eta_kalkulatu())


def Stacking_process(lana, arff_fitxategiak):
    for f_izena in arff_fitxategiak:
        if os.path.isfile(f_izena):
            for l in lana:
                print(f_izena)
                Stacking(os.path.join(IRTEERA_DIREKTORIOA, f_izena), [SAILKATZAILEAK[i] for i in l[0]], SAILKATZAILEAK[l[1]])


def main():
    global hasiera_data, guztira
    hasiera_data = dt.now()
    guztira = 4*len(SAILKATZAILEAK)*2

    for f_izena in os.listdir(IRTEERA_DIREKTORIOA):
        if os.path.isfile(os.path.join(IRTEERA_DIREKTORIOA, f_izena)) and aukeratutako_convert_filtro(f_izena):
            Stacking(os.path.join(IRTEERA_DIREKTORIOA, f_izena), [SAILKATZAILEAK[5], SAILKATZAILEAK[9]], SAILKATZAILEAK[7])
            continue
            for s in SAILKATZAILEAK:
                Bagging(os.path.join(IRTEERA_DIREKTORIOA, f_izena), s)
                Boosting(os.path.join(IRTEERA_DIREKTORIOA, f_izena), s)

def lanak_sortu1(cpus):
    i = 0
    lanak = [[] for i in range(0,cpus)]
    for c in itertools.combinations([j for j in range(0, len(SAILKATZAILEAK))], 3):
        lanak[i % cpus].append(c)
        i += 1
    return lanak

def lanak_sortu2(cpus):
    i = 0
    lanak = [[] for i in range(0,cpus)]
    for c in itertools.combinations([0,1,4,5,6,7,8,14,16,18], 3):
        lanak[i % cpus].append(c)
        i += 1
    return lanak

def lanak_sortu3(cpus):
    i = 0
    lanak = [[] for i in range(0,cpus)]
    aukerak = [[5, 6, 7, 8], [1, 5, 10, 18], [15, 16, 17, 18], [10, 11, 12, 13], [0, 11, 12, 14]]
    meta = [0, 1, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18]
    for j in aukerak:
        for k in meta:
            lanak[i % cpus].append((j, k))
            i += 1
    return lanak

def arff_kopiatu(cpus):
    fitxategiak = [[] for i in range(0,cpus)]
    denbora_marka = dt.now().strftime(f"%Y%m%d%H%M%S")
    for f_izena in os.listdir(IRTEERA_DIREKTORIOA):
        if os.path.isfile(os.path.join(IRTEERA_DIREKTORIOA, f_izena)) and aukeratutako_convert_filtro(f_izena):
            for c in range(0,cpus):
                temp_dir = tempfile.gettempdir()
                temp_path = os.path.join(temp_dir, f_izena.replace(".arff", '_'+str(c)+'_'+denbora_marka+".arff"))
                print(temp_path)
                shutil.copy2(os.path.join(IRTEERA_DIREKTORIOA, f_izena), temp_path)
                fitxategiak[c].append(temp_path)
    return fitxategiak

def main_multiprocess():
    mn = multiprocessing.Manager()
    cpus = multiprocessing.cpu_count()
    lanak = lanak_sortu3(cpus)
    fitxategiak = arff_kopiatu(cpus)
    prozesuak = []

    for i in range(0, cpus):
        # Inicializar proceso con las variables necesarias
        p = multiprocessing.Process(target=Stacking_process, name="Stacking_"+str(i), args=(lanak[i], fitxategiak[i], ))
        prozesuak.append(p)
        p.start()

    try:
        while True:
            pass
    except KeyboardInterrupt:
        pass

    for p in prozesuak:
        p.join()
        p.terminate()

def test():
    print(lanak_sortu1(16))

if __name__ == "__main__":
    try:
        #print(lanak_sortu(16))
        main_multiprocess()
        #test()
    except KeyboardInterrupt:
        exit()