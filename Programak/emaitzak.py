import os
import re
import sys

OUTPUT = "output"
OUTPUT_MULT = "output/multisailkatzaileak"
OUTPUT_FILTER = "output/filter"

class Emaitza:
    def __init__(self, db=None, sailkatzailea=None, zuzen=None, oker=None, sailkatzaileak=None):
        self.db = db
        self.sailkatzailea = sailkatzailea
        self.sailkatzaileak = sailkatzaileak
        if zuzen != None: 
            self.zuzen = int(zuzen)
        else:
            self.zuzen = 0

        if oker != None: 
            self.oker = int(oker)
        else:
            self.oker = 0
    
    def guztira(self):
        return self.zuzen + self.oker

    def zuzen_kant(self):
        return self.zuzen

    def oker_kant(self):
        return self.oker

    def zuzen_tasa(self):
        if self.guztira() == 0:
            return 0
        return self.zuzen / self.guztira()

    def oker_tasa(self):
        return self.oker / self.guztira()

    def db(self):
        return self.db
    
    def sailkatzailea(self):
        return self.sailkatzailea

    def konbinaketa_da(self):
        return not self.sailkatzaileak is None

    def sailkatzaileak(self):
        return self.sailkatzaileak

    def sailkatzailea_izena(self):
        if self.sailkatzaileak is None:
            return self.sailkatzailea
        else:
            return self.sailkatzailea+"_"+"_".join(self.sailkatzaileak)


class EmaitzaZerrenda:
    def __init__(self):
        self.zerrenda = []
        self.db_zerrenda = []
        self.sailkatzaile_zerrenda = []

    def gehitu(self, ema: Emaitza):
        self.zerrenda.append(ema)
        self.__db_gehitu(ema.db)
        self.__sailkatzailea_gehitu(ema.sailkatzailea_izena())
    
    def __db_gehitu(self, db):
        if not db in self.db_zerrenda:
            self.db_zerrenda.append(db)

    def __sailkatzailea_gehitu(self, sailkatzailea):
        if not sailkatzailea in self.sailkatzaile_zerrenda:
            self.sailkatzaile_zerrenda.append(sailkatzailea)

    def emaitzak(self):
        return self.emaitzak

    def dbak(self):
        return self.db_zerrenda

    def sailkatzaileak(self):
        return self.sailkatzaile_zerrenda

    def dbko_emaitzak(self, db):
        tmp = []
        for e in self.zerrenda:
            if db == e.db():
                tmp.append(e)
        return tmp

    def sailkatzaileko_emaitzak(self, sailkatzailea):
        tmp = []
        for e in self.zerrenda:
            if sailkatzailea == e.sailkatzailea_izena():
                tmp.append(e)
        return tmp

    def dbko_sailkatzaileko_emaitza(self, db, sailkatzailea):
        for e in self.zerrenda:
            if db == e.db and sailkatzailea == e.sailkatzailea_izena():
                return e
        return None

def informazioa_lortu(izena):
    r1 = re.search(r"(?P<convert>[^_]+)_(?P<filtroa>[^_]+)_(?P<sailkatzailea>[^_\.]+)_?(?P<sailkatzaileak>[^.]*)?", izena)
    sailkatzaileak = None
    if (s := r1.group("sailkatzaileak")) != '':
        sailkatzaileak = s.split("_")
    return (r1.group("convert"), r1.group("filtroa"), r1.group("sailkatzailea"), sailkatzaileak)

def lortu_emaitza(file):
    cross_validation = False

    convert, filtroa, sailkatzailea, sailkatzaileak = informazioa_lortu(os.path.basename(file))

    with open(file, 'r') as f:
        while line := f.readline():
            if line.startswith("=== Stratified cross-validation ==="):
                cross_validation = True
            
            if cross_validation and line.startswith("Correctly Classified Instances"):
                correct = line
                incorrect = f.readline()
                
                return Emaitza(db=convert+"_"+filtroa, sailkatzailea=sailkatzailea, zuzen=lerroa(correct), oker=lerroa(incorrect), sailkatzaileak=sailkatzaileak)
        return Emaitza(db=convert+"_"+filtroa, sailkatzailea=sailkatzailea, sailkatzaileak=sailkatzaileak)


def lerroa(line):
    p = re.compile("[a-zA-Z\s]*([0-9]*) .*")
    return p.search(line).group(1)


def db_sailkatzailea(izena):
    tmp = izena.split("_")
    return (tmp[0]+'_'+tmp[1], tmp[2])


def emaitzak2csv(emaitzak: EmaitzaZerrenda):
    with open("./emaitzak/emaitzak.csv", 'w') as f:
        for s in emaitzak.sailkatzaile_zerrenda:
            f.write(f";\"{str(s)}\"")
        f.write('\n')

        
        for d in emaitzak.db_zerrenda:
            f.write(str(d))
            for s in emaitzak.sailkatzaile_zerrenda:
                tmp = emaitzak.dbko_sailkatzaileko_emaitza(d, s)
                if tmp != None:
                    balioa = str(tmp.zuzen_tasa()).replace('.', ',')
                    f.write(f";\"{balioa}\"")
                else:
                    f.write(';')
            f.write('\n')


def main():
    emaitza_zerrenda = EmaitzaZerrenda()

    # for filename in os.listdir(OUTPUT):
    #     file = os.path.join(OUTPUT, filename)
        
    #     if os.path.isfile(file):
    #         emaitza_zerrenda.gehitu(lortu_emaitza(file))

    # for filename in os.listdir(OUTPUT_MULT):
    #     file = os.path.join(OUTPUT_MULT, filename)
        
    #     if os.path.isfile(file):
    #         emaitza_zerrenda.gehitu(lortu_emaitza(file))

    for filename in os.listdir(OUTPUT_FILTER):
        file = os.path.join(OUTPUT_FILTER, filename)
        
        if os.path.isfile(file):
            emaitza_zerrenda.gehitu(lortu_emaitza(file))
    emaitzak2csv(emaitza_zerrenda)


if __name__ == "__main__":
    main()