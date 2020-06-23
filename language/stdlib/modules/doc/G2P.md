
<a name="0x1_G2P"></a>

# Module `0x1::G2P`

### Table of Contents

-  [Struct `MoneyOrders`](#0x1_G2P_MoneyOrders)
-  [Function `initialize`](#0x1_G2P_initialize)
-  [Function `deposit`](#0x1_G2P_deposit)



<a name="0x1_G2P_MoneyOrders"></a>

## Struct `MoneyOrders`



<pre><code><b>resource</b> <b>struct</b> <a href="#0x1_G2P_MoneyOrders">MoneyOrders</a>
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>

<code>spent_money_orders: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>

<code>expiration_time: u64</code>
</dt>
<dd>

</dd>
<dt>

<code>public_key: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_G2P_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="#0x1_G2P_initialize">initialize</a>(sender: &signer, num_orders: u64, validity_us: u64, public_key: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="#0x1_G2P_initialize">initialize</a>(sender: &signer,
                      num_orders: u64,
                      validity_us: u64,
                      public_key: vector&lt;u8&gt;,
) {
    // TODO: add initialize with length <b>to</b> the vector
    <b>let</b> spent_money_orders = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>();
    <b>let</b> i = 0;
    <b>while</b> (i &lt; num_orders) { // TODO: <b>move</b> <b>to</b> bit-vector (num_orders + 7) / 8) {
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> spent_money_orders, 0);
        i = i + 1;
    };

    move_to(sender, <a href="#0x1_G2P_MoneyOrders">MoneyOrders</a> {
        spent_money_orders: spent_money_orders,
        expiration_time: <a href="LibraTimestamp.md#0x1_LibraTimestamp_now_microseconds">LibraTimestamp::now_microseconds</a>() + validity_us,
        public_key: public_key,
    });
}
</code></pre>



</details>

<a name="0x1_G2P_deposit"></a>

## Function `deposit`



<pre><code><b>public</b> <b>fun</b> <a href="#0x1_G2P_deposit">deposit</a>(_receiver_vasp: &signer, sender_vasp: address, receiver_user_public_key: vector&lt;u8&gt;, seq_num: u64, sender_vasp_signature: vector&lt;u8&gt;, _receiver_user_signature: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="#0x1_G2P_deposit">deposit</a>(_receiver_vasp: &signer,
                   sender_vasp: address,
                   receiver_user_public_key: vector&lt;u8&gt;,
                   seq_num: u64,
                   sender_vasp_signature: vector&lt;u8&gt;,
                   _receiver_user_signature: vector&lt;u8&gt;,
) <b>acquires</b> <a href="#0x1_G2P_MoneyOrders">MoneyOrders</a> {
    <b>let</b> money_orders = borrow_global_mut&lt;<a href="#0x1_G2P_MoneyOrders">MoneyOrders</a>&gt;(sender_vasp);

    // Verify the sender_vasp_signature
    <b>let</b> message = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>();
    // TODO: append the domain authenticator
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> message, <a href="LCS.md#0x1_LCS_to_bytes">LCS::to_bytes</a>(&seq_num));
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> message, receiver_user_public_key);
    <b>assert</b>(<a href="Signature.md#0x1_Signature_ed25519_verify">Signature::ed25519_verify</a>(sender_vasp_signature, *&money_orders.public_key, message), 8001);
    // TODO: verify the
    // money_orders.spent_money_orders[seq_num] = 1;
}
</code></pre>



</details>
