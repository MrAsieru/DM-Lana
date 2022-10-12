import os
import re

output_karpeta = 'output'

class Emaitza:
    def __init__(self, db=None, sailkatzailea=None, zuzen=None, oker=None):
        self.db = db
        self.sailkatzailea = sailkatzailea
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


class EmaitzaZerrenda:
    def __init__(self):
        self.zerrenda = []
        self.db_zerrenda = []
        self.sailkatzaile_zerrenda = []

    def gehitu(self, ema: Emaitza):
        self.zerrenda.append(ema)
        self.__db_gehitu(ema.db)
        self.__sailkatzailea_gehitu(ema.sailkatzailea)
    
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
            if sailkatzailea == e.sailkatzailea():
                tmp.append(e)
        return tmp

    def dbko_sailkatzaileko_emaitza(self, db, sailkatzailea):
        for e in self.zerrenda:
            if db == e.db and sailkatzailea == e.sailkatzailea:
                return e
        return None


def lortu_emaitza(file):
    cross_validation = False
    with open(file, 'r') as f:
        while line := f.readline():
            if line.startswith("=== Stratified cross-validation ==="):
                cross_validation = True
            
            if cross_validation and line.startswith("Correctly Classified Instances"):
                correct = line
                incorrect = f.readline()
                db, sailkatzailea = db_sailkatzailea(os.path.basename(file))
                return Emaitza(db, sailkatzailea, lerroa(correct), lerroa(incorrect))
        return Emaitza()


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

    for filename in os.listdir(output_karpeta):
        file = os.path.join(output_karpeta, filename)
        
        if os.path.isfile(file):
            emaitza_zerrenda.gehitu(lortu_emaitza(file))
    emaitzak2csv(emaitza_zerrenda)


if __name__ == "__main__":
    main()