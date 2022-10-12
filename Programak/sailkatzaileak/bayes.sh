function BayesNet () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - BayesNet exekutatzen"
    java -classpath weka.jar weka.classifiers.bayes.BayesNet -t "$arff" -x 10 -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 3 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5  1> "output/${irudi_mota}_${arff_mota}_BayesNet" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function NaiveBayes () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - NaiveBayes exekutatzen"
    java -classpath weka.jar weka.classifiers.bayes.NaiveBayes -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_NaiveBayes" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function NaiveBayesMultinomial () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - NaiveBayesMultinomial exekutatzen"
    java -classpath weka.jar weka.classifiers.bayes.NaiveBayesMultinomial -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_NaiveBayesMultinomial" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function NaiveBayesMultinomialText () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - NaiveBayesMultinomialText exekutatzen"
    java -classpath weka.jar weka.classifiers.bayes.NaiveBayesMultinomialText -P 0 -M 3.0 -norm 1.0 -lnorm 2.0 -stopwords-handler weka.core.stopwords.Null -tokenizer "weka.core.tokenizers.WordTokenizer -delimiters \" \\r\\n\\t.,;:\\\'\\\"()?!\"" -stemmer weka.core.stemmers.NullStemmer -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_NaiveBayesMultinomialText" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function NaiveBayesMultinomialUpdateable () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - NaiveBayesMultinomialUpdateable exekutatzen"
    java -classpath weka.jar weka.classifiers.bayes.NaiveBayesMultinomialUpdateable -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_NaiveBayesMultinomialUpdateable" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}

function NaiveBayesUpdateable () {
    # 1: arff fitxategia (lekua)
    arff=$1

    irudi_mota=$(irudiMotaLortu "$(basename $arff)")
    arff_mota=$(arffMotaLortu "$(basename $arff)")
    echo "${irudi_mota}_${arff_mota} - NaiveBayesUpdateable exekutatzen"
    java -classpath weka.jar weka.classifiers.bayes.NaiveBayesUpdateable -t "$arff" -x 10  1> "output/${irudi_mota}_${arff_mota}_NaiveBayesUpdateable" 2> /dev/null
    orain=$(($orain + 1))
    echo "Eginda: ${orain}/${guztira} ($(denbora)) ETA:($(geratzenDa))"
}