#!/bin/sh

certszipr3="artifacts_certs_r3.zip"
cmszipr1="artifacts_cms_v1.zip"
inputdir="./providers"
outputdir="./output/certs"

# Requires an input: the TA file to test
test_ta () {
    tafile=$1
    resultsfile=$2

    printf "\nTesting %s\n" $tafile

    # openssl always exits with 0, so we can't use exit status to tell if the cert was valid :/
    ossl_output=$(openssl verify -check_ss_sig -CAfile $tafile $tafile 2>&1)
    ossl_status=$?

    # print it out for the logs
    echo "$ossl_output"

    tafileBasename=$(basename $tafile)
    oid=${tafileBasename%_ta.pem}  # remove the suffix "_ta.pem"

    # test for an error
    if if (( ossl_status == 0 )); then
        echo "Certificate Validation Result: SUCCESS"
        echo $oid,Y >> $resultsfile
    else
        echo "Certificate Validation Result: FAIL"
        echo $oid,N >> $resultsfile
    fi
}

# First, recurse into any provider dir
for providerdir in $(ls -d $inputdir/*/); do
    provider=$(basename $providerdir)

    # process certs
    zip=$providerdir$certszipr3
    printf "Unziping %s\n" $zip
    unzip -o $zip -d $providerdir/"artifacts_certs_r3"

    # Start the results CSV file
    mkdir -p $outputdir
    resultsfile=$outputdir${provider}_oqsprovider.csv
    echo "key_algorithm_oid,test_result" > $resultsfile

    # test each TA file
    for tafile in $(ls ${providerdir}artifacts_certs_r3/*_ta.pem); do
        test_ta "$tafile" "$resultsfile"
    done
done

