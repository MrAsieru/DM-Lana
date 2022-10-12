irteera_karpeta='../irteera';
# java -classpath weka.jar weka.core.WekaPackageManager -install-package imageFilters

ORIGINAL_ARFF='../irteera/ImageFilter_IK15.arff'

ACCF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_ACCF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_ACCF.arff.tmp"
    printf "\tACCF"

    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.AutoColorCorrelogramFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

BPPF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_BPPF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_BPPF.arff.tmp"
    printf "\tBPPF"
    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.BinaryPatternsPyramidFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

CLF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_CLF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_CLF.arff.tmp"
    printf "\tCLF"
    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.ColorLayoutFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

EHF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_EHF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_EHF.arff.tmp"
    printf "\tEHF"
    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.EdgeHistogramFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

FCTHF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_FCTHF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_FCTHF.arff.tmp"
    printf "\tFCTHF"
    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.FCTHFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

FOHF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_FOHF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_FOHF.arff.tmp"
    printf "\tFOHF"
    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.FuzzyOpponentHistogramFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

GF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_GF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_GF.arff.tmp"
    printf "\tGF"
    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.GaborFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

JPEGCF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_JPEGCF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_JPEGCF.arff.tmp"
    printf "\tJPEGCF"
    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.JpegCoefficientFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

PHOGF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_PHOGF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_PHOGF.arff.tmp"
    printf "\tPHOGF"
    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.PHOGFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

SCHF () {
    # 1: Irudien direktorioa
    irudiak=$1

    arff_in=$ORIGINAL_ARFF
    irudiakIzena=$(basename $irudiak)
    arff_out="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_SCHF.arff"
    arff_tmp="$(dirname $arff_in)/ImageFilter_${irudiakIzena}_SCHF.arff.tmp"
    printf "\tSCHF"
    java -classpath weka.jar weka.Run weka.filters.unsupervised.instance.imagefilter.SimpleColorHistogramFilter -i "${arff_in}" -D "${irudiak}" -o "${arff_out}" 2> /dev/null
    java -classpath weka.jar weka.filters.unsupervised.attribute.RemoveType -T string -i "${arff_out}" -o "${arff_tmp}" 2> /dev/null
    mv "${arff_tmp}" "${arff_out}"
}

# Argazki karpeta bakoitzerako
for k in $irteera_karpeta/*/ ; do
    printf "\n$(basename $k):"
    ACCF "$k"
    BPPF "$k"
    CLF "$k"
    EHF "$k"
    FCTHF "$k"
    FOHF "$k"
    GF "$k"
    JPEGCF "$k"
    PHOGF "$k"
    SCHF "$k"
done

