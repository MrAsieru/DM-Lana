function DecisionStump () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - DecisionStump exekutatzen"
    java -classpath weka.jar weka.classifiers.trees.DecisionStump -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_DecisionStump" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function HoeffdingTree () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - HoeffdingTree exekutatzen"
    java -classpath weka.jar weka.classifiers.trees.HoeffdingTree -L 2 -S 1 -E 1.0E-7 -H 0.05 -M 0.01 -G 200.0 -N 0.0 -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_HoeffdingTree" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function J48 () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - J48 exekutatzen"
    java -classpath weka.jar weka.classifiers.trees.J48 -C 0.25 -M 2 -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_J48" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function J48Consolidated () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - J48Consolidated exekutatzen"
    java -classpath weka.jar weka.Run weka.classifiers.trees.J48Consolidated -C 0.25 -M 2 -Q 1 -RM-C -RM-N 99.0 -RM-B -2 -RM-D 50.0 -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_J48Consolidated" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function LMT () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - LMT exekutatzen"
    java -classpath weka.jar weka.classifiers.trees.LMT -I -1 -M 15 -W 0.0 -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_LMT" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function RandomForest () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - RandomForest exekutatzen"
    java -classpath weka.jar weka.classifiers.trees.RandomForest -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1 -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_RandomForest" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function RandomTree () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - RandomTree exekutatzen"
    java -classpath weka.jar weka.classifiers.trees.RandomTree -K 0 -M 1.0 -V 0.001 -S 1 -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_RandomTree" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function REPTree () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - REPTree exekutatzen"
    java -classpath weka.jar weka.classifiers.trees.REPTree -M 2 -V 0.001 -N 3 -S 1 -L -1 -I 0.0 -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_REPTree" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}