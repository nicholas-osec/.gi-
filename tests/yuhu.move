#[test_only]
module yuhu::YUHU_TEST;

use sui::coin::{Self, TreasuryCap};
use sui::test_scenario::{Self, next_tx, ctx};

public struct YUHU_TEST has drop {}

#[test]
public fun test_coin_create() {
    let owner = @0x0010;
    let user = @0x0020;
    let user2 = @0x0030;

    let mut scenario = test_scenario::begin(owner);

    let witness: YUHU_TEST = YUHU_TEST {};

    let (treasury, metadata) = coin::create_currency(
        witness,
        6,
        b"YUHU",
        b"yuhu",
        b"azx",
        option::none(),
        ctx(&mut scenario),
    );

    
    transfer::public_share_object(metadata);
    

    transfer::public_transfer(treasury, owner);

    next_tx(&mut scenario, owner);
    {
        let mut cap = test_scenario::take_from_sender<TreasuryCap<YUHU_TEST>>(&scenario);
        sui::coin::mint_and_transfer(&mut cap, 4, user, ctx(&mut scenario));
        sui::coin::mint_and_transfer(&mut cap, 10, user, ctx(&mut scenario));
        transfer::public_transfer(cap, owner);
    };

    next_tx(&mut scenario, user);
    {
        let mut user_cap = test_scenario::take_from_sender<coin::Coin<YUHU_TEST>>(&scenario);
        assert!(coin::value(&user_cap) == 10);
        let transfer_portion = coin::split(&mut user_cap, 5, ctx(&mut scenario));
        transfer::public_transfer(transfer_portion, user2);
        assert!(coin::value(&user_cap) == 5);
        transfer::public_transfer(user_cap, user);
    };

    next_tx(&mut scenario, user2);
    {
        let user2_cap = test_scenario::take_from_sender<coin::Coin<YUHU_TEST>>(&scenario);
        assert!(coin::value(&user2_cap) == 5);
        transfer::public_transfer(user2_cap, user2);
    };
    test_scenario::end(scenario);
}