source ./sailkatzaileak/bayes.sh
source ./sailkatzaileak/functions.sh
source ./sailkatzaileak/lazy.sh
source ./sailkatzaileak/trees.sh

# java -classpath weka.jar weka.core.WekaPackageManager -install-package J48Consolidated

irteera_karpeta='../irteera';

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

if [[ $1 == "-delete" ]]; then
    for file in "output/*" ; do
        rm $file
    done
fi

guztira=$((60*21)) # Arff guztira * egiten diren sailkaketa guztiak
orain=0
hasiera=$(date +%s)

# DB bakoitzerako
for db in $irteera_karpeta/*.arff ; do
    if [[ $db != *"IK15"* ]]; then
        # Derrigorrezkoak (8)
        KNN $db 1
        KNN $db 3
        KNN $db 7
        KNN $db 11
        J48 $db
        RandomForest $db
        NaiveBayes $db
        BayesNet $db
        
        # Aukerazkoak (13)
        NaiveBayesMultinomial $db
        NaiveBayesMultinomialText $db
        NaiveBayesMultinomialUpdateable $db
        NaiveBayesUpdateable $db
        KStar $db
        LWL $db
        DecisionStump $db
        HoeffdingTree $db
        J48Consolidated $db
        LMT $db
        RandomTree $db
        REPTree $db
        SMO $db
    fi
done