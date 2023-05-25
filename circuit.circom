template ECDSAVerify(n, k) {
    signal input signature_r[k];  
    signal input signature_s[k];  
    signal input message_hash[k];  
    signal input public_key[2][k];  
    signal output verification_result;  

    // step 1: get prime & order from secp256k1
    var prime_number[100] = get_secp256k1_prime(n, k);  
    var order[100] = get_secp256k1_order(n, k);  

    // step 2: compute multiplicative inverse of signature_s mod order 
    var signature_s_inverse[100] = mod_inv(n, k, signature_s, order);
    signal signature_s_inverse_formatted[k];
    component signature_s_inverse_range_check[k];

    // step 3: check s∈[1, n-1]
    for (var i = 0; i < k; i++) {  
        signature_s_inverse_formatted[i] <-- signature_s_inverse[i];  
        signature_s_inverse_range_check[i] = Num2Bits(n);  
        signature_s_inverse_range_check[i].in <== signature_s_inverse_formatted[i]; 
    }

    // step 4: checks if sinv is the inverse of s 
    component signature_s_inverse_check = BigMultModP(n, k);
    for (var i = 0; i < k; i++) {  
        signature_s_inverse_check.a[i] <== signature_s_inverse_formatted[i];
        signature_s_inverse_check.b[i] <== signature_s[i];
        signature_s_inverse_check.p[i] <== order[i];
    }  
    for (var i = 0; i < k; i++) {
        if (i > 0) {
            signature_s_inverse_check.out[i] === 0;
        }
        if (i == 0) {
            signature_s_inverse_check.out[i] === 1;
        }
    }      

    // step 5: compute (h * sinv) * G (G is the generation point of the secp256k1 curve)
    // step 6: compute (r * sinv) mod n
    // step 7: compute (h * sinv) * G + (r * sinv) * pubkey


    // last step: compare R == R'
    verification_result <== result_comparator.out;  

}

function get_secp256k1_prime(n, k){
   // Returns the prime number p in correct circom format 
}
function get_secp256k1_order(n, k){
   // Returns the order n in correct circom format 
}   
function mod_inv(n, k, s, order){
   // Returns the multiplicative inverse of s mod order 
}

component main = ECDSAVerify();