# extract_promoter
A perl script to extract a bed of regulatory regions for a gene list with Gencode GTF as input

### download human gtf in human folder (need 1.7 GB of space)
```
## permission execution
chmod +x download_human_gencode.sh
## call usage
./download_human_gencode.sh

## create "human" folder containing "latest_gencode.gtf" file
```

### download human gtf in mouse folder (need 1 GB of space)
```
## permission execution
chmod +x download_mouse_gencode.sh
## call usage
./download_mouse_gencode.sh

## create "mouse" folder containing "latest_gencode.gtf" file
```
### usage for extract promoter in bed format
```
## permission execution
chmod +x extract_promoter.pl
## call usage
./extract_promoter
```


![res](https://github.com/cdesterke/extract_promoter/blob/main/usage.png)

### example
```
## download human Gencode GTF and unzip it
./extract_promoter.pl --gtf human/latest_gencode.gtf --genes gene_list.txt --output promoters.bed --upstream 1000 --downstream 100

```

## REFERENCES

> Mudge JM, Carbonell-Sala S, Diekhans M, Martinez JG, Hunt T, Jungreis I, Loveland JE, Arnan C, Barnes I, Bennett R, Berry A, Bignell A, Cerdán-Vélez D, Cochran K, Cortés LT, Davidson C, Donaldson S, Dursun C, Fatima R, Hardy M, Hebbar P, Hollis Z, James BT, Jiang Y, Johnson R, Kaur G, Kay M, Mangan RJ, Maquedano M, Gómez LM, Mathlouthi N, Merritt R, Ni P, Palumbo E, Perteghella T, Pozo F, Raj S, Sisu C, Steed E, Sumathipala D, Suner MM, Uszczynska-Ratajczak B, Wass E, Yang YT, Zhang D, Finn RD, Gerstein M, Guigó R, Hubbard TJP, Kellis M, Kundaje A, Paten B, Tress ML, Birney E, Martin FJ, Frankish A. GENCODE 2025: reference gene annotation for human and mouse. Nucleic Acids Res. 2024 Nov 20:gkae1078. doi: 10.1093/nar/gkae1078. Epub ahead of print. PMID: 39565199.
