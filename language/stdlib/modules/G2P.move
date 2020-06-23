// 8001 - signature did not verify
address 0x1 {

    module G2P {
        use 0x1::Vector;
        use 0x1::LCS;
        use 0x1::LibraTimestamp;
        use 0x1::Signature;

        resource struct MoneyOrders {
            spent_money_orders: vector<u8>,
            expiration_time: u64,
            public_key: vector<u8>, // TODO: replace with vasp's compliance public key
        }

        public fun initialize(sender: &signer,
                              num_orders: u64,
                              validity_us: u64,
                              public_key: vector<u8>,
        ) {
            // TODO: add initialize with length to the vector
            let spent_money_orders = Vector::empty();
            let i = 0;
            while (i < num_orders) { // TODO: move to bit-vector (num_orders + 7) / 8) {
                Vector::push_back(&mut spent_money_orders, 0);
                i = i + 1;
            };
            
            move_to(sender, MoneyOrders {
                spent_money_orders: spent_money_orders,
                expiration_time: LibraTimestamp::now_microseconds() + validity_us,
                public_key: public_key,
            });
        }

        // sender_vasp creates receiver_user_public_key and receiver_user_secret_key pair, and signs the [seq_num, receiver_user_public_key] with the sender_vasp.MoneyOrders.public_key to create sender_vasp_signature
        // user receives the receiver_user_secret_key off-chain from sender_vasp
        // user signs the [receiver_vasp.address, sender_vasp, seq_num] to create receiver_user_signature
        // TODO: to think if this is enough
        public fun deposit(_receiver_vasp: &signer,
                           sender_vasp: address,
                           receiver_user_public_key: vector<u8>,
                           seq_num: u64,
                           sender_vasp_signature: vector<u8>,
                           _receiver_user_signature: vector<u8>,
        ) acquires MoneyOrders {
            let money_orders = borrow_global_mut<MoneyOrders>(sender_vasp);
            
            // Verify the sender_vasp_signature
            let message = Vector::empty();
            // TODO: append the domain authenticator
            Vector::append(&mut message, LCS::to_bytes(&seq_num));            
            Vector::append(&mut message, receiver_user_public_key);
            assert(Signature::ed25519_verify(sender_vasp_signature, *&money_orders.public_key, message), 8001);
            // TODO: verify the 
            // money_orders.spent_money_orders[seq_num] = 1;
        }
    }
}
