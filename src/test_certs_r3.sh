#!/bin/bash

# Requires an input: the TA file to test
test_ta () {
    tafile=$1
    resultsfile=$2

    printf "\nTesting %s\n" $tafile

    # openssl always exits with 0, so we can't use exit status to tell if the cert was valid :/
    ossl_output=$(openssl x509 -in $tafile -text -noout 2>&1)

    # print it out for the logs
    echo "$ossl_output"

    oid=$(echo $tafile | cut -d "_" -f 1)

    # test for an error
    if (echo $ossl_output | grep "error\|Unable to load certificate" >/dev/null); then
        echo "Certificate Validation Result: FAIL"
        echo $oid,N >> $resultsfile
    else
        echo "Certificate Validation Result: SUCCESS"
        echo $oid,Y >> $resultsfile
    fi
}

# First, recurse into any provider dir
for provider in $(ls -d */); do
    provider=${provider%*/}  # remove the trailing "/"
    for zip in $(ls -d $provider/*.zip); do
        printf "Unziping %s\n" $zip
        unzip -o $zip

        # Start the results CSV file    
        resultsfile=${provider}_oqsprovider.csv
        echo "key_algorithm_oid,test_result" > $resultsfile

        # test each TA file
        for tafile in $(ls *_ta.pem); do
            test_ta "$tafile" "$resultsfile"
        done
    done
done

