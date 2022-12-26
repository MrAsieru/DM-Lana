import matplotlib.pyplot as plt

emaitza_fitx_equalize = "wrapper_emaitzak_convert-equalize_PHOGF_SMO.txt"
emaitza_fitx_unsharp = "wrapper_emaitzak_convert-unsharp5x5_EHF_LMT.txt"

datuak_equalize = []
datuak_unsharp = []

with open(emaitza_fitx_equalize, "r") as f:
    i = 1
    while l := f.readline():
        tmp = l.split(";")
        datuak_equalize.append((tmp[0], i, float(tmp[1])))
        i += 1

with open(emaitza_fitx_unsharp, "r") as f:
    i = 1
    while l := f.readline():
        tmp = l.split(";")
        datuak_unsharp.append((tmp[0], i, float(tmp[1])))
        i += 1

# Lehenengoa
x = [x for (n, x, y) in datuak_unsharp]
y = [y for (n, x, y) in datuak_unsharp]

# Plot
fig, ax = plt.subplots()
ax.plot(x, y, linewidth=2.0, label="Wrapper")
plt.hlines(y=97.11, xmin=0, xmax=len(x)-1, colors='red', linestyles='--', lw=2, label="Wrapper barik")

# Informazioa
plt.title("convert-unsharp5x5_EHF_LMT")
plt.ylabel("Asmatze-tasa (%)")
plt.xlabel("Aukeratutako atributu kantitatea")
plt.legend(loc="lower right")

# Erakutsi
#plt.show()

ax.set(ylim=(90, 100))
plt.show()