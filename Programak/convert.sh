mkdir ../irteera/convert-edge2
mogrify -path ../irteera/convert-edge2/ -edge 2 ../irteera/ordenatuak/*

mkdir ../irteera/convert-gaussianblur3x3
mogrify -path ../irteera/convert-gaussianblur3x3/ -gaussian-blur 3x3 ../irteera/ordenatuak/*

mkdir ../irteera/convert-grayscale
mogrify -path ../irteera/convert-grayscale/ -grayscale Rec709Luma ../irteera/ordenatuak/*

mkdir ../irteera/convert-unsharp5x5
mogrify -path ../irteera/convert-unsharp5x5/ -unsharp 5x5 ../irteera/ordenatuak/*

mkdir ../irteera/convert-equalize
mogrify -path ../irteera/convert-equalize/ -equalize ../irteera/ordenatuak/*