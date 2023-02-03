// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

struct Admin {
    address payable id;
}

enum user {
    candidate,
    voter
}
struct User {
    address id;
    user user_type;
}

contract EVote {
    Admin admin;

    constructor() {
        admin.id = payable(msg.sender);
    }

    // function register() public view {
    //     User memory new_user = User({id: msg.sender, user_type: user.voter});
    // }
}
