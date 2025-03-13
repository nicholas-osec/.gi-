zmodule yuhu::yuhu {
    use sui::coin::{Self, TreasuryCap};
    public struct YUHU has drop {}

    /// Intialize the token with treasury and metadata
    fun init(witness: YUHU, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness, 6, b"YUHU", b"yuhu", b"azx", option::none(), ctx
        );

        transfer::public_share_object(metadata);

        transfer::public_transfer(treasury, ctx.sender());
    }

    public fun mint(
        treasury_cap: &mut TreasuryCap<YUHU>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient)
    }
}
