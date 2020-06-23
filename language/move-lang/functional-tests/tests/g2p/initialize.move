//! account: bob, 1000000, 0, validator
//! account: alice

//! new-transaction
//! sender: alice
script {
    use 0x1::G2P;
    fun main(sender: &signer) {
        G2P::initialize(sender, 100, 1000000, x"");
    }
}
// check: EXECUTED


