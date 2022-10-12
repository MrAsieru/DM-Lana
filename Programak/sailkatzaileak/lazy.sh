function KNN () {
    # 1: arff fitxategia (lekua)
    # 2: K zenbakia
    arff=$1
    k=$2

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - ${k}-NN exekutatzen"
    java -classpath weka.jar weka.classifiers.lazy.IBk -K $k -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_${k}-NN" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function KStar () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - KStar exekutatzen"
    java -classpath weka.jar weka.classifiers.lazy.KStar -B 20 -M a -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_KStar" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function LWL () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - LWL exekutatzen"
    java -classpath weka.jar weka.classifiers.lazy.LWL -U 0 -K -1 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"" -W weka.classifiers.trees.DecisionStump -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_LWL" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}