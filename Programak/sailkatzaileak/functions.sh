function SMO () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - SMO exekutatzen"
    java -classpath weka.jar weka.classifiers.functions.SMO -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.PolyKernel -E 1.0 -C 250007" -calibrator "weka.classifiers.functions.Logistic -R 1.0E-8 -M -1 -num-decimal-places 4" -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_SMO" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}