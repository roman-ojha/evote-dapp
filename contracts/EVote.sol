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
    bool does_exist;
}

contract EVote {
    Admin admin;
    mapping(address => User) users;

    constructor() {
        admin.id = payable(msg.sender);
    }

    function login() public {
        if (!users[msg.sender].does_exist) {
            // if user doesn't exist already
            User memory new_user = User({
                id: msg.sender,
                user_type: user.voter,
                does_exist: true
            });
            users[msg.sender] = new_user;
        }
    }

    function get_user() public view returns (User memory) {
        require(users[msg.sender].does_exist, "User doesn't exist");
        return users[msg.sender];
    }
}
