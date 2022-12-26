irteera_karpeta='../irteera';
output_karpeta='output/multisailkatzaileak'

aukeratutakoConvertEtaFiltro() {
    tmp=0
    if [[ $1 == *"equalize"* || $1 == *"unsharp"* ]]; then
        tmp=$(($tmp + 1))
    fi

    if [[ $1 == *"EHF"* || $1 == *"PHOGF"* ]]; then
        tmp=$(($tmp + 1))
    fi

    echo $tmp
}

arffMotaLortu () {
    # 1: arff fitxategia (lekua)
    tmp=$1
    tmp=${tmp%.*}
    tmp=${tmp#*_}
    tmp=${tmp#*_}
    echo "$tmp"
}

irudiMotaLortu () {
    # 1: arff fitxategia (lekua)
    tmp=$1
    tmp=${tmp%.*}
    tmp=${tmp#*_}
    tmp=${tmp%_*}
    echo "$tmp"
}

sailkatzaileaLortu() {
    sailk=$1
    echo ${sailk[@]}
    if [[ ${sailk[0]} == *"IBk"* ]] ; then
        echo "${sailk[3]}-NN"
    else
        tmp=${sailk[0]}
        tmp=${tmp%%' '*}
        tmp=${tmp#${tmp%.*}}
        tmp=${tmp#*.}
        tmp=${tmp%*' '}
        echo "$tmp"
    fi
}

denbora () {
    tmp=$(date +%s)
    desb=$(($tmp - $hasiera))
    echo $(date -d@${desb} -u +%H:%M:%S)
}

geratzenDa () {
    tmp=$(date +%s)
    tmp2=$((($guztira - $orain)*(($tmp - $hasiera)/$orain)))
    echo $(date -d@${tmp2} -u +%H:%M:%S)
}

function kalkulatutaDago() {
    irudi_mota=$1
    filtro_mota=$2
    sailk=$3
    multi=$4

    tmp=0
    for em in $output_karpeta/* ; do
        if [[ $em == *"$filtro_mota"* && $em == *"$irudi_mota"* && $em == *"$sailk"* && $em == *"$multi"* ]] ; then
            tmp=1
        fi
    done
    echo $tmp
}

function Bagging() {
    # 1: arff fitxategia (lekua)
    # 2: classifier configurazioa
    arff=$1
    classifier=$2
    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    sailkatzaile_mota=$(sailkatzaileaLortu "$classifier")

    if [[ $(kalkulatutaDago $irudi_mota $arff_mota $sailkatzaile_mota "Bagging") == 0 ]] ; then
        echo "${irudi_mota}_${arff_mota} - Bagging(${sailkatzaile_mota}) exekutatzen"
        java -Xmx5120M -classpath weka.jar weka.classifiers.meta.Bagging -t "${arff}" -P 100 -S 1 -num-slots 1 -I 10 -W "${classifier[@]}" 1> "${output_karpeta}/${irudi_mota}_${arff_mota}_Bagging_${sailkatzaile_mota}" 2> /dev/null
    else
        echo "${irudi_mota}_${arff_mota} - Bagging(${sailkatzaile_mota}) kalkulatuta dago"
    fi
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function Boosting() {
    # 1: arff fitxategia (lekua)
    # 2: classifier configurazioa
    arff=$1
    classifier=$2
    echo "${classifier[@]}"
    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    sailkatzaile_mota=$(sailkatzaileaLortu "${classifier[@]}")
    if [[ $(kalkulatutaDago $irudi_mota $arff_mota $sailkatzaile_mota "Boosting") == 0 ]] ; then
        echo "${irudi_mota}_${arff_mota} - Boosting(${sailkatzaile_mota}) exekutatzen"
        java -Xmx5120M -classpath weka.jar weka.classifiers.meta.AdaBoostM1 -t "${arff}" -P 100 -S 1 -I 10 -W "${classifier[@]}" 1> "${output_karpeta}/${irudi_mota}_${arff_mota}_Boosting_${sailkatzaile_mota}" 2> /dev/null
    else
        echo "${irudi_mota}_${arff_mota} - Boosting(${sailkatzaile_mota}) kalkulatuta dago"
    fi
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function Vote3() {
    # 1: arff fitxategia (lekua)
    # 2: classifier configurazioa
    arff=$1
    classifier1=$2
    classifier2=$3
    classifier3=$4

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    sailk1=$(sailkatzaileaLortu "${classifier1[@]}")
    sailk2=$(sailkatzaileaLortu "${classifier2[@]}")
    sailk3=$(sailkatzaileaLortu "${classifier3[@]}")
    echo "${irudi_mota}_${arff_mota} - Vote(${sailk1}-${sailk2}-${sailk3}) exekutatzen"
    java -Xmx5120M -classpath weka.jar weka.classifiers.meta.Vote -t "${arff}" -S 1 -B "${sailk1}" -B "${sailk2}" -B "${sailk3}" -R AVG 1> "${output_karpeta}/${irudi_mota}_${arff_mota}_Vote_${sailk1}-${sailk2}-${sailk3}" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function Stacking3() {
    # 1: arff fitxategia (lekua)
    # 2: classifier configurazioa
    arff=$1
    classifierM=$2
    classifier1=$3
    classifier2=$4
    classifier3=$5

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    sailk1=$(sailkatzaileaLortu "${classifier1[@]}")
    sailk2=$(sailkatzaileaLortu "${classifier2[@]}")
    sailk3=$(sailkatzaileaLortu "${classifier3[@]}")
    sailkM=$(sailkatzaileaLortu "${classifierM[@]}")
    echo "${irudi_mota}_${arff_mota} - Stacking(${sailkM}=${sailk1}-${sailk2}-${sailk3}) exekutatzen"
    java -Xmx5120M -classpath weka.jar weka.classifiers.meta.Stacking -t "${arff}" -X 10 -M "${sailkM}" -S 1 -num-slots 1 -B "${sailk1}" -B "${sailk2}" -B "${sailk3}" 1> "${output_karpeta}/${irudi_mota}_${arff_mota}_Stacking_${sailkM}=${sailk1}-${sailk2}-${sailk3}" #2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

if [ ! -d "${output_karpeta}" ]; then
    mkdir "${output_karpeta}"
fi

if [[ $1 == "-delete" ]]; then
    for file in "output/multisailkatzaileak/*" ; do
        rm $file
    done
fi

function sailkatzaileak() {
    n=$1
    case $n in
        0)
            s=("weka.classifiers.bayes.BayesNet -- -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 3 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5")
        ;;
        1)    
            s=(weka.classifiers.bayes.NaiveBayes)
        ;;
        2)    
            s=(weka.classifiers.bayes.NaiveBayesMultinomial)
        ;;
        3)    
            s=(weka.classifiers.bayes.NaiveBayesMultinomialUpdateable)
        ;;
        4)    
            s=(weka.classifiers.bayes.NaiveBayesUpdateable)
        ;;
        5)
            s=(weka.classifiers.lazy.IBk -- -K 1 -W 0 -I -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"")
        ;;
        6)    
            s=(weka.classifiers.lazy.IBk -- -K 3 -W 0 -I -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"")
        ;;
        7)    
            s=(weka.classifiers.lazy.IBk -- -K 7 -W 0 -I -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"")
        ;;
        8)    
            s=(weka.classifiers.lazy.IBk -K 11 -W 0 -I -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance -R first-last\"")
        ;;
        9)    
            s=(weka.classifiers.lazy.KStar -- -B 20 -M a)
        ;;
        10)    
            s=(weka.classifiers.trees.HoeffdingTree -- -L 2 -S 1 -E 1.0E-7 -H 0.05 -M 0.01 -G 200.0 -N 0.0)
        ;;
        11)    
            s=(weka.classifiers.trees.J48 -- -C 0.25 -M 2)
        ;;
        12)    
            s=(weka.classifiers.trees.LMT -- -I -1 -M 15 -W 0.0)
        ;;
        13)    
            s=(weka.classifiers.trees.RandomForest -- -P 100 -I 100 -num-slots 1 -K 0 -M 1.0 -V 0.001 -S 1)
        ;;
        14)    
            s=(weka.classifiers.trees.RandomTree -- -K 0 -M 1.0 -V 0.001 -S 1)
        ;;
        15)    
            s=(weka.classifiers.trees.REPTree -- -M 2 -V 0.001 -N 3 -S 1 -L -1 -I 0.0)
        ;;
        *)
            s=16
    esac
    
    local sailk_conf=$s
    use_array sailk_conf
}

function make_array() {
    
}

guztira=$((4*$(sailkatzaileak -1)*2)) # Arff guztira * egiten diren sailkaketa guztiak
orain=0
hasiera=$(date +%s)

for db in $irteera_karpeta/*.arff ; do
    if [[ $db != *"IK15"* && $(aukeratutakoConvertEtaFiltro $db) == 2 ]]; then
        for ((i = 0; i < $(sailkatzaileak -1); i++)) ; do
            sailk="$(sailkatzaileak $i)"
            echo ${sailk[0]}
            #Bagging $db $sailk
            #Boosting $db $sailk           
        done
    fi
done